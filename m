Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757348Ab0FIJtZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 05:49:25 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53841 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757299Ab0FIJtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 05:49:23 -0400
Date: Wed, 9 Jun 2010 10:58:02 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Yedire, Sandeep" <syedire@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Ext2/3 Filesystem Analysis
Message-ID: <20100609105802.62d2ddce@lxorguk.ukuu.org.uk>
In-Reply-To: <AANLkTinfPl-JAP_4ZzdzJf2uyWcZ_0qfRQiT16_D8Pdd@mail.gmail.com>
References: <AANLkTinfPl-JAP_4ZzdzJf2uyWcZ_0qfRQiT16_D8Pdd@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> With Ext3:
> Filesystem block at Sector 0 is being updated more frequently at ratio
> of 5.5 to 6 times that of data block.
> Filesystem block(super block copies) are being updated at around
> 1.5times the frequency compared to data block.
> 
> Has anyone come across this kind of behaviour with these filesystems
> on NAND Flash?

ext2/3 are not intended to be used with flash - they do not wear level,
in fact the journal and some other blocks will get very heavily used
compared to other blocks.

See the MTD drivers and related file systems/mapping layers (UBIFS etc)
