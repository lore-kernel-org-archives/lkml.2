Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab3AFXgJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 18:36:09 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:51304 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311Ab3AFXgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 18:36:07 -0500
MIME-Version: 1.0
In-Reply-To: <20121219095616.GV2261@intel.com>
References: <1355818296.11831.287.camel@bichao>
	<20121219095616.GV2261@intel.com>
Date: Mon, 7 Jan 2013 00:36:07 +0100
Message-ID: <CACRpkdaw7Yc0OetPWK7Cv=JsVPOs6b1Tr-=4jE5Vz4oTD6f07Q@mail.gmail.com>
Subject: Re: [PATCH] SPI: SSP SPI Controller driver v3
From: Linus Walleij <linus.walleij@linaro.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: chao bi <chao.bi@intel.com>, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, sylvain.centelles@intel.com,
        ken.k.mills@intel.com, jun.d.chen@intel.com, alan@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2012 at 10:56 AM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
> On Tue, Dec 18, 2012 at 04:11:36PM +0800, chao bi wrote:
>>
>> This patch is to implement SSP SPI controller driver, which has been applied and
>> validated on intel Moorestown & Medfield platform. The patch are originated by
>> Ken Mills <ken.k.mills@intel.com> and Sylvain Centelles <sylvain.centelles@intel.com>,
>> migrating to lateset Linux mainline SPI framework by Channing <chao.bi@intel.com>
>> and Chen Jun <jun.d.chen@intel.com> according to their integration & validation
>> on Medfield platform.
>
> This is the same IP block as used in PXA, right? With few modifications
> here and there. Is there a reason not to use spi-pxa2xx.c?

This needs to be investigated. Two drivers for the same or closely related
hardware block is never a good sign...

Yours,
Linus Walleij
