Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932764Ab2KNI6i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 03:58:38 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37935 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932130Ab2KNI6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 03:58:37 -0500
From: Dimitar Popov <dimitar.georgiev.popov@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: DMA Errors from SATA Controller with 4G Memory Remapping Enabled
Date: Wed, 14 Nov 2012 09:58:33 +0100
Message-ID: <1572001.X28n9jtBC3@darkstar>
User-Agent: KMail/4.9.3 (Linux/3.6.6-1-ARCH; KDE/4.9.3; x86_64; ; )
In-Reply-To: <20121113223421.7129577d@pyramind.ukuu.org.uk>
References: <1871872.oE0GX69FUF@darkstar> <20121113223421.7129577d@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 November 2012 22:34:21 Alan Cox wrote:
> On Tue, 13 Nov 2012 23:08:07 +0100
> 
> Dimitar Popov <dimitar.georgiev.popov@gmail.com> wrote:
> > Hi all,
> > 
> > I have an old computer with motherboard ASUS SK8N with AMD Opteron 148 and
> > 4 GiB of DDR400. There is an onboard SATA Promise RAID controller working
> > in IDE mode (i.e. not as RAID controller) with 2 SATA disks. In order to
> > use all 4 GiB RAM I need to enable the "4G Memory Remapping" option from
> > the BIOS.
> > However, if I do that I receive the following errors:
> Pretty sure I know what that is as it's come up befor but the person
> reporting it vanished without testing fixes.
> 
> Can you run tests on a fix

Yes, I can run tests - it is easily reproducible: I just need to start writing 
on one of the disks. (sorry for the two messages)
