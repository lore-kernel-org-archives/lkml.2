Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239Ab2LQSJy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 13:09:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48941 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752142Ab2LQSJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 13:09:53 -0500
Message-ID: <50CF5FB4.8090305@zytor.com>
Date: Mon, 17 Dec 2012 10:08:52 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Thomas Renninger <trenn@suse.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] ACPI: Overriding ACPI tables via initrd only works
 with an initrd
References: <1351694147-10904-1-git-send-email-trenn@suse.de> <1351694147-10904-4-git-send-email-trenn@suse.de> <20121217092802.GA31947@liondog.tnic>
In-Reply-To: <20121217092802.GA31947@liondog.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2012 01:28 AM, Borislav Petkov wrote:
> Hi guys,
>
> this one sanitizes the Kconfig entry prompt so can we pick it up for
> -rc1 or later, please?
>

Hm... all these are actually cleanups or fixes for the stuff that is now 
upstream, I believe... as minor fixes I think these can be pushed 
post-rc1 if we don't get to them sooner but it looks like they are all 
needed.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

