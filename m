Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671Ab0IWPPJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 11:15:09 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42845 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568Ab0IWPPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 11:15:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=bNgX+Wr4PcvZrZV7pOkYlar4bMR+OXFNPiCeM0gv3Upgjwl09+iY/OO5Y9aGSbW9Fl
         87W/jdZ7zWuAlfPVVPhZ4Os5RM0ucXzzcjFltf2P2tHvQ//SriiC53Eg8eaWIeYJPP6o
         wop1OoU8CU3zOcLveFfo9Ve5M/pGJNO4IOATU=
Subject: Re: ahci rmmodable and shouldn't
From: Pedro Francisco <pedrogfrancisco@gmail.com>
To: Tejun Heo <htejun@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
In-Reply-To: <4C97DBE2.8070707@gmail.com>
References: <201009162256.04765.pedrogfrancisco@gmail.com>
	 <47010.148.87.67.141.1284674336.squirrel@www.xenotime.net>
	 <4C933A8F.2080305@gmail.com> <1284892106.2650.4.camel@sundae-v2>
	 <4C9602E4.4090007@gmail.com> <1284974726.11757.9.camel@sundae-v2>
	 <4C9729D7.70500@gmail.com>  <4C972C60.8010506@gmail.com>
	 <1285015465.26023.10.camel@sundae-v2> <4C97DB80.4060403@gmail.com>
	 <4C97DBE2.8070707@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Sep 2010 16:14:35 +0100
Message-ID: <1285254875.2858.15.camel@sundae-v2>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Ter, 2010-09-21 at 00:10 +0200, Tejun Heo wrote:
> On 09/21/2010 12:09 AM, Tejun Heo wrote:
> > Hello,
> > 
> > On 09/20/2010 10:44 PM, Pedro Francisco wrote:
> >> To which tree shall I apply it? It currently fails both on Linus'
> >> linux-2.6 and
> >> git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata-dev.git .
> > 
> > Hmm... weird.  It's against Linus' tree.  Checking, yeap, it applies
> > cleanly to 2.6.36-rc4, commit 2422084a (Merge branch 'for-linus' of
> > git://git.kernel.org/pub/scm/linux/kernel/git/mattst88/alpha-2.6).
> 
> Attaching the patch just in case.

I must have forgotten "-p1" since it now worked fine.

Anyway, the patch works on 2.6.36-rc4 :)

Sorry for the late reply but compiling and running it took a bit longer
than expected.
-- 
Pedro

