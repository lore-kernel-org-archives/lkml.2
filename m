Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734Ab0GNKRP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 06:17:15 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:65490 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565Ab0GNKRO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 06:17:14 -0400
MIME-Version: 1.0
In-Reply-To: <8F2A7B0931C16B4C99DDA3B283A436301401CFB6@ntilml01.nuvoton.com>
References: <8F2A7B0931C16B4C99DDA3B283A436301401CFB6@ntilml01.nuvoton.com>
From: Ohad Ben-Cohen <ohad@bencohen.org>
Date: Wed, 14 Jul 2010 13:16:51 +0300
Message-ID: <AANLkTikH-TbcimtO2kEa7yNpLxIBHdShyuRBfgojyvtH@mail.gmail.com>
Subject: Re: Request to submit driver for Nuvoton TPM I2C device (WPCT301)
To: Dan.Morav@nuvoton.com
Cc: linux-kernel@vger.kernel.org, debora@linux.vnet.ibm.com,
        srajiv@linux.vnet.ibm.co, m.selhorst@sirrix.com,
        Michal.Schramm@nuvoton.com, Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

On Wed, Jul 14, 2010 at 12:31 PM,  <Dan.Morav@nuvoton.com> wrote:
> Hello,
>
> I'd like to submit a new TPM driver.

Thank you for submitting a new driver.

However please note that your code is licensed under GPLv3:

 * Nuvoton TPM I2C Device Driver Interface for WPCT301,
 * based on the TCG TPM Interface Spec version 1.2.
 * Specifications at www.trustedcomputinggroup.org
 *
 * Copyright (C) 2010, Nuvoton Technology Corporation.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.

The Linux kernel is licensed under GPLv2 which is not compatible with
GPLv3, so please (consider to) relicense to GPLv2 and only then
resubmit.

Also please check out Documentation/SubmittingPatches for guidance how
to submit code to the Linux kernel (no attachments please, instead use
plain in-line patches text).

Thanks,
Ohad.



>
> Attached is a new driver for Nuvoton TPM with I2C interface.
> - tpm_i2c.c is the driver code
> - tpm.h and Makefile are added only for reference and stand alone compilation
>
> The driver should be part of the drivers/char/tpm.
> The driver uses standard Linux I2C bus driver interface to access the I2C bus.
> The driver uses standard Linux TPM driver API.
> The driver was tested on Linux kernel v2.6.31.
>
> Please advice if any further information is required.
>
> Regards,
> Dan.
> _________________________
> Dan Morav
> Advanced PC
> Nuvoton Technology Israel Ltd.
> Office +972.9.970.2388
> eMail: dan.morav@nuvoton.com
>
>
> ===========================================================================================
> The privileged confidential information contained in this email is intended for use only by the addressees as indicated by the original sender of this email. If you are not the addressee indicated in this email or are not responsible for delivery of the email to such a person, please kindly reply to the sender indicating this fact and delete all copies of it from your computer and network server immediately. Your cooperation is highly appreciated. It is advised that any unauthorized use of confidential information of Nuvoton is strictly prohibited; and any information in this email irrelevant to the official business of Nuvoton shall be deemed as neither given nor endorsed by Nuvoton.
>
> ===========================================================================================
> The privileged confidential information contained in this email is intended for use only by the addressees as indicated by the original sender of this email. If you are not the addressee indicated in this email or are not responsible for delivery of the email to such a person, please kindly reply to the sender indicating this fact and delete all copies of it from your computer and network server immediately. Your cooperation is highly appreciated. It is advised that any unauthorized use of confidential information of Nuvoton is strictly prohibited; and any information in this email irrelevant to the official business of Nuvoton shall be deemed as neither given nor endorsed by Nuvoton.
>
