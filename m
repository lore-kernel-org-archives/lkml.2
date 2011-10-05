Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758018Ab1JEPPj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 11:15:39 -0400
Received: from mail.skyhub.de ([78.46.96.112]:42588 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757554Ab1JEPPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 11:15:37 -0400
Date: Wed, 5 Oct 2011 17:15:33 +0200
From: Borislav Petkov <bp@alien8.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: =?utf-8?B?5p2O5pyd5piO?= <chaoming_li@realsil.com.cn>,
        linux-wireless@vger.kernel.org,
        "'LKML'" <linux-kernel@vger.kernel.org>
Subject: Re: =?utf-8?B?562U5aSNOiDnrZTlpI06IOetlA==?= =?utf-8?B?5aSNOg==?=
 3.1-rc6+ rtl8192se issue
Message-ID: <20111005151533.GA18592@gere.osrc.amd.com>
References: <CD4D8CF16C39438E82FE8241C9AF80F4@realsil.com.cn>
 <20110921185816.GA2036@gere.osrc.amd.com>
 <791179BCE62F4954AB936E6CAC9CA977@realsil.com.cn>
 <4E7AAB8B.40900@lwfinger.net>
 <20110922075115.GA17640@liondog.tnic>
 <6452E68488784D0EA32E4BDF1B941EFB@realsil.com.cn>
 <20110923103339.GA26078@gere.osrc.amd.com>
 <4E7CB504.4060904@lwfinger.net>
 <20110928131823.GA2693@gere.osrc.amd.com>
 <4E83D092.7010405@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E83D092.7010405@lwfinger.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 28, 2011 at 08:57:38PM -0500, Larry Finger wrote:
> Asa you probably do not want to kill your standard tree, unpack the
> Realtek version normally, cd to where it unpacked, and do a make.
> Once it builds, do the following:
> 
> sudo modprobe -rv rtl8192se
> sudo modprobe -v mac80211
> sudo insmod rtlwifi.ko
> sudo insmod rtl8192se/rtl8192se.ko
> 
> >
> >Also, any preferred module parameters settings you want me to test?
> 
> Try it first with the default parameters. If that fails, use "ips=0".

Ok, I can cautiosly say now that after a couple days of running the
Realtek version that the box runs just fine, no hiccups whatsoever.

Larry, you said in an earlier mail that you've gone through the
rtl8192se changes and weren't optimistic with the attached diff you sent
me. What about the rtlwifi changes, is there something in Realtek's
version which is missing upstream that would cause the sluggishness?

Thanks.

-- 
Regards/Gruss,
Boris.
