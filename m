Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347Ab0LLQCl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 11:02:41 -0500
Received: from hera.kernel.org ([140.211.167.34]:45712 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752855Ab0LLQCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 11:02:39 -0500
Message-ID: <4D04F211.6080602@kernel.org>
Date: Sun, 12 Dec 2010 17:02:25 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
        Jaroslav Kysela <perex@perex.cz>, Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH 09/30] sound: don't use flush_scheduled_work()
References: <1292086307-19211-1-git-send-email-tj@kernel.org> <1292086307-19211-10-git-send-email-tj@kernel.org> <s5hk4jfbc94.wl%tiwai@suse.de> <4D0492CB.2010702@kernel.org> <s5hhbejb1yr.wl%tiwai@suse.de> <20101212124041.GD15189@opensource.wolfsonmicro.com>
In-Reply-To: <20101212124041.GD15189@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 12 Dec 2010 16:02:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2010 01:40 PM, Mark Brown wrote:
> On Sun, Dec 12, 2010 at 01:38:36PM +0100, Takashi Iwai wrote:
> 
>> Meanwhile, I wondered whether it's the really wanted behavior for
>> that particular code path, thus the previous question to Liam.
> 
> Yes, it's desired behaviour.  That's what the old code was trying to do.
> I've not seen the original patch, could someone resend it to me please
> (or send a pointer)?

Weirdly, lkml seemed to have eaten the original postings.  I can't
find them in any archive.  The following is the original patch.

  http://git.kernel.org/?p=linux/kernel/git/tj/wq.git;a=commitdiff;h=01f8126c2e14245cf0ba11a25fb9a291710066e1;hp=cd591981a8d06d6aaca6d7ef2412d12a7adf47ed

Thanks.

-- 
tejun
