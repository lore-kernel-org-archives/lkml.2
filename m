Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281Ab0FWJ4Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 05:56:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:45791 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824Ab0FWJ4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 05:56:23 -0400
Subject: Re: linux-firmware tree vs. linux-firmware-from-kernel tree
From: David Woodhouse <dwmw2@infradead.org>
To: Thomas =?ISO-8859-1?Q?B=E4chler?= <thomas@archlinux.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4C21D941.9030904@archlinux.org>
References: <4C21D941.9030904@archlinux.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Jun 2010 10:56:18 +0100
Message-ID: <1277286978.29898.6.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.31.4 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-23 at 10:52 +0100, Thomas Bächler wrote:
> Hello David,
> 
> After switching from 'make firmware_install' to using the firmware files
> from the linux-firmware tree, I received a bug report about missing
> firmware files. While investigating, I noticed that the following
> commits are in linux-firmware-from-kernel, but not in linux-firmware:
> 
> Ken Kawasaki (1):
>       pcnet_cs: add cis of KTI PE520 pcmcia network card
> 
> Michael Chan (2):
>       bnx2: Update firmwares and update version to 2.0.8.
>       bnx2: Update 5709 MIPS firmware and version to 2.0.15.
> 
> Vladislav Zolotarov (1):
>       bnx2x: Use firmware 5.2.13
> 
> Is there a specific reason why they are missing? Can you merge these
> commits into linux-firmware (I did it locally and it went fine, apart
> from a minor conflict in the WHENCE file).

Yeah, it needs a manual merge, which I don't do very often -- partly
because I don't expect us to be adding _new_ non-GPL firmware to the
kernel tree. That's just insane.

-- 
dwmw2

