Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587Ab2HVHst (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 03:48:49 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:52281 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757408Ab2HVHsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 03:48:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: AnilKumar Ch <anilkumar@ti.com>
Subject: Re: [PATCH v2] lis3lv02d: Add STMicroelectronics lis331dlh digital accelerometer
Date: Wed, 22 Aug 2012 07:48:38 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: gregkh@linuxfoundation.org, eric.piel@tremplin-utc.net, jic23@cam.ac.uk,
        greg@kroah.com, akpm@linux-foundation.org,
        broonie@opensource.wolfsonmicro.com, dmitry.torokhov@gmail.com,
        linux-kernel@vger.kernel.org
References: <1345617039-27469-1-git-send-email-anilkumar@ti.com>
In-Reply-To: <1345617039-27469-1-git-send-email-anilkumar@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201208220748.39106.arnd@arndb.de>
X-Provags-ID: V02:K0:JXnRS3VxDWcj0uFv685qFT+vEaPFrJDbuOo09D0G9G7
 oFDdx9xcjzmvU5Kl+GwBbHrHycwBeQgRBxu8o9tahvmbcHx8LH
 o4K9+LPBDEgmPhaWpBlhdFPe85hJNQ0KQZfA/Lwpk/wGC9IvZc
 HD2Fib19plWv865GLgy/pixx1LbLIjnRYDP15aurDjZCPXnE/8
 O5wLvm/292GTXSlq3nVk/vUfVr1ALvIomen4w1bvU4/NmVqPkv
 fBD7NLZtQl1zdVzcC30xTskgi9wMv7D0QPepoanSPFG6LdIsHb
 meMG/9CLqkz4XtuwwmwUP8tJX5B+Me8yS+ZcgqEAbVuohY8xNT
 wkeVdZfSK4rSR5Uei9DA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 August 2012, AnilKumar Ch wrote:
> This patch adds support for lis331dlh digital accelerometer to the
> lis3lv02d driver family. Adds ID field for detecting the lis331dlh
> module, based on this ID field lis3lv02d driver will export the
> lis331dlh module functionality.
> 
> Signed-off-by: AnilKumar Ch <anilkumar@ti.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
