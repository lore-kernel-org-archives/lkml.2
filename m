Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab1CZBj3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 21:39:29 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:55725 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751546Ab1CZBj1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 21:39:27 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19KtGI5G+dKVEluFRmLtgeRjMQoAuuOsj2NOq57lv
	zSBMH1pdCuXrfY
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Harry Wei <jiaweiwei.xiyou@gmail.com>
Subject: Re: [PATCH] staging/trivial: Fix common spelling mistakes
Date: Sat, 26 Mar 2011 02:39:23 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37; KDE/4.4.5; x86_64; ; )
Cc: greg@kroah.com, linux-kernel@vger.kernel.org, trivial@kernel.org,
        jkosina@suse.cz, joe@perches.com
References: <alpine.LNX.2.00.1103141259500.19969@pobox.suse.cz> <1300139875-8688-1-git-send-email-peterhuewe@gmx.de> <20110315031418.GB3372@gmail.com>
In-Reply-To: <20110315031418.GB3372@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201103260239.23708.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 15 März 2011, 04:14:20 schrieb Harry Wei:
> > This patch fixes some very common spelling mistakes in drivers/staging
> Hi peter,
>      I have sense that you should split this
> patch for patches, which one patch just do
> one spelling mistakes.
> 
> But there are so many spelling mistakes.
> I wanna help you with this stuff. Would you
> like to assign some to me. I am so pleasure
> for this.


Hi Harry,

(sorry for my late reply)

thanks for you help and I really appreciate your offer.
I've split up the patch for the staging directory into 27 patches, one for 
each affected directory, since this was the easiest way to split my big old 
patch ;)

As you know there's still the big "fix common spelling mistakes" patch for the 
trivial tree (i.e. everything but the staging directory) which is still 
pending, and probably won't apply anymore ;)
So it might be a good idea to split this one up as well, and for this your 
help comes handy.

If this is fine with Jiri I'd suggest this splitting:

One patch each for:
arch/
crypto/
fs/
include/
kernel/
lib/
mm/
net/
scripts/
security/
sound/

And for drivers/ one patch for each subsystem/directory,
with the exception of drivers/media/ - this one I'd split into 
media/dvb/
media/video/
and the remaining media


If you want to help me the easiest way would be that I update the patch to the 
current trivial tree and then send it to you, you apply it with patch (not git 
am) and then commit each subdirectory and write a nice commit message  and 
send it to the list ;) 

But I'd like to hear Jiri's opinion first.


Thanks,
Peter

