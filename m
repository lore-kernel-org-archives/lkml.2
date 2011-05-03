Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048Ab1ECKgC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 06:36:02 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:63166 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab1ECKgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 06:36:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [RFC PATCH 4/4] ARM: Xilinx: Adding Xilinx board support
Date: Tue, 3 May 2011 12:35:41 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, johnlinn@comcast.net,
        nicolas pitre <nicolas.pitre@linaro.org>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        grant likely <grant.likely@secretlab.ca>,
        john linn <john.linn@xilinx.com>
References: <90477150.2231869.1304372815517.JavaMail.root@sz0140a.emeryville.ca.mail.comcast.net> <201105030958.14698.arnd@arndb.de> <20110503085220.GL28001@n2100.arm.linux.org.uk>
In-Reply-To: <20110503085220.GL28001@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105031235.41888.arnd@arndb.de>
X-Provags-ID: V02:K0:6/OohOpUd41xarSBt3R94xAwHYEi3rYRLEXX6G1/T+6
 IZGgH51XndMvWRRoudgiBvW5vAqcU/JhrGiCijTty/Sc1BCsyk
 X9Q89pWvv25iARiACierFEsfGHkgWObgLkDWgSDkEMbBXpWkST
 aVc44SbYGOOcqpBM6LcqxOdMljbyuN9JNOv7sDDdJww5dHkFSX
 TRPqli2tPSHrUpnqxbbbQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 May 2011, Russell King - ARM Linux wrote:
> On Tue, May 03, 2011 at 09:58:14AM +0200, Arnd Bergmann wrote:
> > On Tuesday 03 May 2011 01:01:18 Russell King - ARM Linux wrote:
> > > It is preferable to use the same mapping, as it ensures that you're not
> > > going to create incompatible aliases.
> > 
> > Is aliasing a problem for MMIO mappings? I would think that you can
> > ioremap registers anywhere and as often as you want because they are
> > never cacheable.
> 
> Provided the type and sharability is identical then there is no problem.
> I wasn't referring to multiple ioremap()s of the same region - that
> should be fine as the same attributes will be used.  If you mix ioremap()
> and iotable_init() then you _could_ have problems if you don't use
> MT_DEVICE in the iotable.
> 
> What I'm basically saying is that mixing the methods of creating these
> mappings makes it much easier to get tripped up over these issues.
 
Ok, makes sense.

Thanks,

	Arnd
