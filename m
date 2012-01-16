Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490Ab2APFrH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 00:47:07 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:46962 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750740Ab2APFrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 00:47:05 -0500
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <B567DBAB974C0544994013492B949F8E3812BEEB67@EXMAIL03.scwf.nsc.com>
References: <1326372302.5729.1.camel@phoenix> <B567DBAB974C0544994013492B949F8E3812BEEB67@EXMAIL03.scwf.nsc.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Mon, 16 Jan 2012 13:46:42 +0800
Message-ID: <CAF+7xWmaiBXuteFyACAJrpExTjQsFo5D+Z98+ZumCdF_5EKBSg@mail.gmail.com>
Subject: Re: [PATCH] power_supply: Add MODULE_DEVICE_TABLE for lp8727 charger
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "Jeong, Daniel" <Daniel.Jeong@nsc.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/16 Kim, Milo <Milo.Kim@ti.com>:
>> Add MODULE_DEVICE_TABLE to setup modalias for lp8727.
>
> Autoloading this module is not required.
Well, Then I'll send a patch to just add terminating entry for
i2c_device_id table.

> The LP8727 includes a charger function with the micro/mini USB interface.
> Charging a battery and detecting which cable is inserted, this kind of job must be started at the beginning of system boot.
> So the lp8727 driver should be loaded before an user-space accesses this driver.
If this driver can be built as a module, people may load/unload the
module anytime ( and I think this is nothing to do with autoloading).

Regards,
Axel
