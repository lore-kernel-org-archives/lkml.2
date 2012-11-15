Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992651Ab2KOBsY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 20:48:24 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:58972 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992557Ab2KOBsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 20:48:22 -0500
Message-ID: <50A449DC.7070206@linaro.org>
Date: Wed, 14 Nov 2012 17:48:12 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Anton Vorontsov <anton.vorontsov@linaro.org>
CC: Jason Wessel <jason.wessel@windriver.com>, Colin Cross <ccross@google.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        kernel-team@android.com, kgdb-bugreport@lists.sourceforge.net
Subject: Re: [PATCH 0/7] KDB: Kiosk (reduced capabilities) mode
References: <20121016011724.GB23146@lizard>
In-Reply-To: <20121016011724.GB23146@lizard>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12111501-5518-0000-0000-0000094CEDEE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2012 06:17 PM, Anton Vorontsov wrote:
> Hello Jason,
>
> Just as promised, I'm resending the series after the merge window.
>
> This patchset implements "kiosk" mode for KDB debugger. The mode reduces
> kdb features, so that it is no longer possible to leak sensitive data via
> the debugger, and not possible to change program flow in a predefined
> manner by an ordinary user. Root can control the capability.
>
> There are a few patches, some are just cleanups, some are churn-ish
> cleanups, but inevitable. And the rest implements the mode -- after all
> the preparations, everything is pretty straightforward.
>
Ping? Did this patchset fall through the cracks?  Any issues left to 
address?

thanks
-john

