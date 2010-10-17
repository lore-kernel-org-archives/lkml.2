Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461Ab0JQSKz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 14:10:55 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:37993 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932226Ab0JQSKx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 14:10:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=Ibpl6NooukxAkde8IKfgH6wNn8/B7L4VxPX5lvcyxpnlS1p2xLiia1CY/QlkaAcgdI
         vutQMFGpvdstNpbhsOn/lG2UkmzmxfTyldvREaLyl2tNDBkB7wOhHvPovVBz840s/znp
         97i0ku4UWnQxCWwp7GlzlBhG3o47ayiPNcZac=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: [2.6.36-rc8] ERROR: "dump_write" [fs/binfmt_aout.ko] undefined!
Date: Sun, 17 Oct 2010 20:10:47 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc7; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <201010161942.03081.maciej.rutecki@gmail.com> <201010170949.EHE37827.MJFLOtSQVFOHFO@I-love.SAKURA.ne.jp>
In-Reply-To: <201010170949.EHE37827.MJFLOtSQVFOHFO@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201010172010.48059.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On niedziela, 17 października 2010 o 02:49:49 Tetsuo Handa wrote:
> Maciej Rutecki wrote:
> > During compiling 2.6.36-rc8:
> > CC [M]  net/wireless/wext-compat.o
> > 
> >   CC [M]  net/wireless/wext-sme.o
> >   CC [M]  net/wireless/lib80211.o
> >   LD [M]  net/wireless/cfg80211.o
> >   Building modules, stage 2.
> >   MODPOST 344 modules
> > 
> > ERROR: "dump_write" [fs/binfmt_aout.ko] undefined!
> > ERROR: "dump_seek" [fs/binfmt_aout.ko] undefined!
> > make[2]: *** [__modpost] B??d 1
> > make[1]: *** [modules] B??d 2
> > make[1]: Opuszczenie katalogu `/usr/src/linux-2.6.36-rc8'
> > make: *** [debian/stamp/build/kernel] B??d 2
> 
> Fixed in 2.6.36-rc8-git1 .
> You can apply
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitd
> iff;h=8fd01d6cfbf75465d84a4e533ed70c5f57b3ff51#patch1 .
> 
Thanks for the information. I will test latest git.

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
