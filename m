Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999Ab0KSKyI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 05:54:08 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50230 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846Ab0KSKyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 05:54:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=ZWU1MnsMV/LA4x5KFf17C6acG4dXXD+ZBR0FqkrdF4tvKjcugnQ8/bEpm2FWIORheS
         5F/A0lnuRZbkMDstXxhfzV1P0tAuq+6Y8cStgdd/JMstOWHjLqB2orIsbi6wdpXUAA0d
         IJecn7RXTuoSPIqo6ZeTpQZt6gu8Voehdt48A=
From: Vasily Khoruzhick <anarsoul@gmail.com>
To: "Lars-Peter Clausen" <lars@metafoo.de>
Subject: Re: [PATCH] ARM: s3x24xx: Fix gpiochip_add complaining.
Date: Fri, 19 Nov 2010 12:53:58 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-gentoo-r1-anarsoul; KDE/4.5.3; i686; ; )
Cc: linux-arm-kernel@lists.infradead.org, Kukjin Kim <kgene.kim@samsung.com>,
        Ben Dooks <ben-linux@fluff.org>,
        Marek Belisko <marek.belisko@open-nandra.com>,
        linux-kernel@vger.kernel.org
References: <1290158139-16105-1-git-send-email-marek.belisko@open-nandra.com> <201011191123.22255.anarsoul@gmail.com> <4CE6547A.9070309@metafoo.de>
In-Reply-To: <4CE6547A.9070309@metafoo.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011191253.58812.anarsoul@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 November 2010 12:42:02 Lars-Peter Clausen wrote:
> Hi
> 
> Well it actually causes problems on systems with external gpio expanders,
> because now the additional banks will take up the space which was meant
> for the gpio expander chip and peripherals connected to it wont be
> accessible.

Ok, but it would be nice to see some runtime soc-type detection for gpiolib. 
s3c2410/s3c2440/s3c2442 doesn't differ too much (actually, they're same in 
gpiopart, s3c2410 lacks some gpiobanks that s3c244[0,2] have, and difference 
in pull-up/pull-down on s3c2440 and s3c2442).
I think it's not good to make artificial restrictions for building single 
binary kernel for these socs.
 
> I sent a patch[1] about this some time ago, but I guess it was never
> applied...

Try pinging Ben or Kukjin :)

Regards
Vasily
