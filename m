Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751694Ab0L2I6F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 03:58:05 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62352 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab0L2I6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 03:58:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=fzhkN0RQgcO1E4aWs752aBUcXBz8VkCxJGhP8GLeafYeax/p55B7gauAml5WN0OOxk
         /XVTiy/ZaqMz5HCLglIR2jVMSjJ6UOydJpEwcl1J+pS+uLac3gcAwvBIDNfLAyqzq24n
         mzvUQv4FISM/d06JEU3Rq8+YZV1H9vxDsqg2I=
MIME-Version: 1.0
In-Reply-To: <AANLkTikq50KLGwS1_=uA=TXz2b=LNzr_TKUSiZu-an1m@mail.gmail.com>
References: <20101229130700.0ef93735.sfr@canb.auug.org.au>
	<AANLkTikq50KLGwS1_=uA=TXz2b=LNzr_TKUSiZu-an1m@mail.gmail.com>
Date: Wed, 29 Dec 2010 10:58:02 +0200
Message-ID: <AANLkTin1pizZM5LttTpYQOo0gPEeV7Jd5uD5RXwnj37Z@mail.gmail.com>
Subject: Re: linux-next: Tree for December 29
From: Anca Emanuel <anca.emanuel@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Building modules, stage 2.
  MODPOST 2808 modules
ERROR: "__tracepoint_snd_soc_jack_irq"
[sound/soc/codecs/snd-soc-wm8994.ko] undefined!
ERROR: "__tracepoint_snd_soc_jack_irq"
[sound/soc/codecs/snd-soc-wm8350.ko] undefined!
ERROR: "__tracepoint_snd_soc_jack_irq"
[sound/soc/codecs/snd-soc-88pm860x.ko] undefined!
WARNING: modpost: Found 59 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=y'
make[2]: *** [__modpost] Error 1
make[1]: *** [modules] Error 2
