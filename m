Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745Ab0LJGUI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 01:20:08 -0500
Received: from mail-ey0-f171.google.com ([209.85.215.171]:48276 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab0LJGUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 01:20:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=sXobUTeHX2DgJMwXN3eSl1Or0ocLzFqZpb670PMR8mqzlxkJCK9QJ+ppcke2cLc1sM
         JcNa5wacBlZxYaFm2Nd16cGbqhjUBk6iXcrDhWGj9xhFEZcl2VNX1me231MqJ6czXp0D
         mZAOB738XU8Mr7xm5j0zu6Za3i6Y1fToDdrCE=
Subject: Re: [PATCH] at91: Refactor Stamp9G20 and PControl G20 board file
From: Igor Plyatov <plyatov@gmail.com>
Reply-To: plyatov@gmail.com
To: Ryan Mallon <ryan@bluewatersys.com>, linux@arm.linux.org.uk,
        Nicolas Ferre <nicolas.ferre@atmel.com>, costa.antonior@gmail.com,
        linux@maxim.org.za, linux-arm-kernel@lists.infradead.org,
        plagnioj@jcrosoft.com, pgsellmann@portner-elektronik.at,
        linux-kernel@vger.kernel.org
In-Reply-To: <1291889759-12281-1-git-send-email-christian.glindkamp@taskit.de>
References: <4CFFE5A9.4040407@bluewatersys.com>
	 <1291889759-12281-1-git-send-email-christian.glindkamp@taskit.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Dec 2010 09:19:58 +0300
Message-ID: <1291961998.3020.0.camel@homepc>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Christian,

> As PControl G20 is a carrier board for the Stamp9G20 SoM, some code can
> be shared. Therefore board-stamp9g20.c is refactored to allow reusing the
> SoM initialization and board-pcontrol-g20.c is modified to use it.
> 
> Signed-off-by: Christian Glindkamp <christian.glindkamp@taskit.de>
> ---
> 
> How about this approach? Compile tested for PControl G20 and run time tested
> for Stamp9G20 EVB and PortuxG20.
> 
> Just a side note: PortuxG20 is not a carrier board for the Stamp9G20. It just
> shares so much with the evaluation board, that it makes sense to put them both
> into the same file. And there is no intention to put other boards into this
> file.

The idea from this patch is clean.
Yours patch does not apply to the kernel from
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git,
but I apply its content by hands and kernels compiled successfully with
stamp9g20_defconfig and pcontrol_g20_defconfig.

Please run ./scripts/checkpatch.pl with you patch and correct all errors
and warnings reported. 

If you will correct this patch, to be applicable, then I will vote to
include it into mainline.

Which kernel repository and branch should I use for the AT91 ARM?
I just want to know - whereto send my next patch to support gms machine?

Best regards!
--
Igor Plyatov



