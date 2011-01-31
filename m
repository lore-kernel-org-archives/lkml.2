Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585Ab1AaUFP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 15:05:15 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55218 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665Ab1AaUFN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 15:05:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=AAMTaBqyF68dXWB1uxpXk9kbu0J3sbBqqoAfhsDB/0sU5zCgOlHOVbaShNUKR752tq
         PaXuY2VyvUylI7qAXyv62Cy8gg97DdPLsKkBWQaMZrfTOuoqTRZrV8ySGcbKLJCa7LKN
         meXKYMetpIwdthe841pto6UkWLiCuOf5C7oQM=
MIME-Version: 1.0
In-Reply-To: <AANLkTinWiG=v-Mwt+tBBSFN43w4f0qifmr+v=mArB0u0@mail.gmail.com>
References: <20110131135147.GB3883@oksana.dev.rtsoft.ru> <20110131154354.GC3819@enneenne.com>
 <20110131160321.GA23546@oksana.dev.rtsoft.ru> <AANLkTikr3LL-+4LObBaCTo7JGTFTRdVbpbbUH4nfJ28X@mail.gmail.com>
 <4D470B42.7050301@metafoo.de> <20110131192242.GB23722@sirena.org.uk>
 <AANLkTi=zc_Ft6K=QP70-fUASO+0pO_2O8Cp6W6LL08MS@mail.gmail.com>
 <20110131193810.GK5123@opensource.wolfsonmicro.com> <AANLkTinWiG=v-Mwt+tBBSFN43w4f0qifmr+v=mArB0u0@mail.gmail.com>
From: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>
Date: Mon, 31 Jan 2011 21:04:32 +0100
Message-ID: <AANLkTi=ySBY3=-kyL0x3GbzmNELWi7Ot=nivuVVwHov6@mail.gmail.com>
Subject: Re: Fwd: [PATCH] bq27x00_battery: Add new properties
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Grazvydas Ignotas <notasas@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds MODULE_DEVICE_TABLE for module bq27x00_battery.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
Tested-by: Pali Rohár <pali.rohar@gmail.com>

--- a/drivers/power/bq27x00_battery.c   2011-01-31 20:58:11.000000000 +0100
+++ b/drivers/power/bq27x00_battery.c   2011-01-31 20:57:05.000000000 +0100
@@ -596,6 +596,7 @@ static const struct i2c_device_id bq27x0
        { "bq27500", BQ27500 },
        {},
 };
+MODULE_DEVICE_TABLE(i2c, bq27x00_id);

 static struct i2c_driver bq27x00_battery_driver = {
        .driver = {
