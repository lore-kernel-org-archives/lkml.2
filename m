Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598Ab2ANUTM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 15:19:12 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:34850 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756207Ab2ANUTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 15:19:10 -0500
Date: Sat, 14 Jan 2012 21:18:56 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Alex Rio <scasbyte@gmail.com>
Cc: guenter.roeck@ericsson.com, linux-kernel@vger.kernel.org,
        Rodolfo Giometti <giometti@linux.it>
Subject: Re: [RFC][PATCH 2/2] hwmon: (w83627ehf) Add GPIO port 3
 functionality
Message-ID: <20120114211856.7e1b816d@endymion.delvare>
In-Reply-To: <CAPbJ=B=_Xubsni7R00kSotDQ9AE9jmhmyRV0gPkXGqAPGrNaXg@mail.gmail.com>
References: <CAPbJ=B=_Xubsni7R00kSotDQ9AE9jmhmyRV0gPkXGqAPGrNaXg@mail.gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jan 2012 19:39:56 -0600, Alex Rio wrote:
> The w83627ehf chip has 5 GPIO ports, currently none of them is supported.
> This patch adds the GPIO port 3 driver with the following functions:
> set/get pin values, direction_in/out, set_debounce.
> The values are also available to the userspace (if requiered)
> in the path /sys/class/gpio by using the export/unexport functions.
> Please look at the REVISIT comment, this is the main reason of the RFC,
> suggestions will be highly appreciated.
> 
> Signed-off-by: Alex Rio <scasbyte@gmail.com>
> ---
>  drivers/hwmon/w83627ehf.c |  188 +++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 188 insertions(+), 0 deletions(-)

This is calling for a MFD driver for these chips. This was proposed in
the past, BTW, but never followed up:
http://lists.lm-sensors.org/pipermail/lm-sensors/2010-February/027795.html

Putting everything in the current driver is not going to be accepted.
It certainly looks pleasant because it's a more simple approach, but
the result would be a complex and unmaintainable driver.

-- 
Jean Delvare
