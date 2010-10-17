Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932623Ab0JQS6Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 14:58:24 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:43893 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932531Ab0JQS6W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 14:58:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=cszRAG9Jz4AdpnC0GG0WU1DucZiiF8CB6Sjn/qluiAPOUQuntlSYNgLNYiRhAZ5KgN
         LOViC/TEYsd8tQff5oLgmL5w35O2bErDk5xArIOojbvdn1McAth2Hh5BwaOCGj3lKbUR
         PIfYxa9rjCVQU4XyoUXNGql6teAZ/qpLi/hDA=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: [2.6.36-rc8] ERROR: "dump_write" [fs/binfmt_aout.ko] undefined!
Date: Sun, 17 Oct 2010 20:58:17 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc7; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <201010161942.03081.maciej.rutecki@gmail.com> <201010170949.EHE37827.MJFLOtSQVFOHFO@I-love.SAKURA.ne.jp>
In-Reply-To: <201010170949.EHE37827.MJFLOtSQVFOHFO@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201010172058.17885.maciej.rutecki@gmail.com>
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
> Regards.

Confirm: 2.6.36-rc8-git3 works OK.

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
