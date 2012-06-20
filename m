Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164Ab2FTKVF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 06:21:05 -0400
Received: from mail.free-electrons.com ([88.190.12.23]:56453 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552Ab2FTKVD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 06:21:03 -0400
X-Greylist: delayed 519 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Jun 2012 06:21:03 EDT
Date: Wed, 20 Jun 2012 12:12:11 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Vishal Nandanwar <operational.people@gmail.com>
Cc: Linux Docs <linux-doc@vger.kernel.org>,
        Linux Embedded Group <linux-embedded@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux USB <linux-usb@vger.kernel.org>,
        Platform driver x86 <platform-driver-x86@vger.kernel.org>
Subject: Re: Need help regarding the USB mass storage driver
Message-ID: <20120620121211.3eb93149@skate>
In-Reply-To: <CAKB833nfHQwdHzCFV6ELrk1-XZT-SN8WxMs=kzO=C8+6foTrDQ@mail.gmail.com>
References: <CAKB833nfHQwdHzCFV6ELrk1-XZT-SN8WxMs=kzO=C8+6foTrDQ@mail.gmail.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Wed, 20 Jun 2012 15:09:20 +0530,
Vishal Nandanwar <operational.people@gmail.com> a écrit :

> I am working on a USB mass storage driver for a pen drive. I have done
> coding as per the USB_skeleton.c file provided in Linux 3.2 source
> code. I could assign the driver to pen drive when pen driver is
> inserted in USB connector.

Why do you need to write a new driver?

Normally, all the USB storage devices conform to the USB Mass Storage
specification, which means that the usb-storage driver of the Linux
kernel can be used for them. There is no need for a separate driver for
each USB storage device, unless of course it doesn't comply with the
USB Mass Storage specification.

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
