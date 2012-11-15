Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992610Ab2KOBpt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 20:45:49 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:36522 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992516Ab2KOBps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 20:45:48 -0500
Message-ID: <50A4493B.3020207@linaro.org>
Date: Wed, 14 Nov 2012 17:45:31 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Anton Vorontsov <anton.vorontsov@linaro.org>
CC: Russell King <linux@arm.linux.org.uk>,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOl?= =?UTF-8?B?Zw==?= 
	<arve@android.com>,
        Colin Cross <ccross@android.com>, Brian Swetland <swetland@google.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        kernel-team@android.com
Subject: Re: [PATCH v10 0/4] ARM: KDB FIQ debugger
References: <20121016003756.GA23146@lizard>
In-Reply-To: <20121016003756.GA23146@lizard>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12111501-2876-0000-0000-00000209FFD3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2012 05:37 PM, Anton Vorontsov wrote:
> Hello Russell,
>
> The KDB/NMI core support has been merged into v3.7-rc1, so the only ARM
> bits are pending now. I believe I addressed all your previous comments,
> but surely there might be something else to improve, thus would be great
> if you could take a look at this.
>
> The patches were rebased onto v3.7-rc1, and this is the only change in
> v10.
>
> Old changelogs and rationale for these patches can be found here:
>
> 	v1-v5, rationale: http://lkml.org/lkml/2012/9/10/2
> 	v6: http://lkml.org/lkml/2012/9/10/2
> 	v7: http://lkml.org/lkml/2012/9/13/367
> 	v8: http://lkml.org/lkml/2012/9/19/525
> 	v9: http://lkml.org/lkml/2012/9/24/538

Just catching up from being on leave, but I've not seen any response to 
this.

Are there objections to this patch set? Or did it just get buried in 
everyone's inbox?

thanks
-john

