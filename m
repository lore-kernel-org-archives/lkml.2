Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024Ab1AaTWq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 14:22:46 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:38686 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227Ab1AaTWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 14:22:45 -0500
Date: Mon, 31 Jan 2011 19:22:42 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Pali Roh??r <pali.rohar@gmail.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Grazvydas Ignotas <notasas@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Fwd: [PATCH] bq27x00_battery: Add new properties
Message-ID: <20110131192242.GB23722@sirena.org.uk>
References: <20110131135147.GB3883@oksana.dev.rtsoft.ru> <20110131154354.GC3819@enneenne.com> <20110131160321.GA23546@oksana.dev.rtsoft.ru> <AANLkTikr3LL-+4LObBaCTo7JGTFTRdVbpbbUH4nfJ28X@mail.gmail.com> <4D470B42.7050301@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D470B42.7050301@metafoo.de>
X-Cookie: Error in operator: add beer
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 08:19:30PM +0100, Lars-Peter Clausen wrote:
> On 01/31/2011 07:07 PM, Pali Roh??r wrote:
> > 2011/1/31 Anton Vorontsov <cbouatmailru@gmail.com>:
> >> On Mon, Jan 31, 2011 at 04:43:56PM +0100, Rodolfo Giometti wrote:

> >>>> +MODULE_ALIAS("i2c:bq27000");
> >>>> +MODULE_ALIAS("i2c:bq27200");
> >>>> +MODULE_ALIAS("i2c:bq27500");

> >> Btw, this is actually another bugfix. Pali, you might want to separate
> >> it into yet another patch.

> > Ok, I separate aliases to new patch.

> The bq27000 is not an I2C device.

Also, even if it were an I2C device this isn't how I2C devices get their
module loading information set up - they use MODULE_DEVICE_TABLE().
