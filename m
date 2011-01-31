Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689Ab1AaTiP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 14:38:15 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37733 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753687Ab1AaTiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 14:38:14 -0500
Date: Mon, 31 Jan 2011 19:38:10 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Grazvydas Ignotas <notasas@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Fwd: [PATCH] bq27x00_battery: Add new properties
Message-ID: <20110131193810.GK5123@opensource.wolfsonmicro.com>
References: <20110131135147.GB3883@oksana.dev.rtsoft.ru>
 <20110131154354.GC3819@enneenne.com>
 <20110131160321.GA23546@oksana.dev.rtsoft.ru>
 <AANLkTikr3LL-+4LObBaCTo7JGTFTRdVbpbbUH4nfJ28X@mail.gmail.com>
 <4D470B42.7050301@metafoo.de>
 <20110131192242.GB23722@sirena.org.uk>
 <AANLkTi=zc_Ft6K=QP70-fUASO+0pO_2O8Cp6W6LL08MS@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=zc_Ft6K=QP70-fUASO+0pO_2O8Cp6W6LL08MS@mail.gmail.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 08:35:47PM +0100, Pali Rohár wrote:

> Can you give me example how to use MODULE_DEVICE_TABLE (if alias is
> not good solution)?

git grep MODULE_DEVICE_TABLE\(i2c

provides quite a few examples.
