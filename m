Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab0IWK0A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 06:26:00 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49762 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751039Ab0IWKZ7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 06:25:59 -0400
Date: Thu, 23 Sep 2010 11:48:45 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Alan Cox <alan@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        David Woodhouse <dwmw2@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86/mrst: add SFI platform device parsing code
Message-ID: <20100923114845.1938d9dc@lxorguk.ukuu.org.uk>
In-Reply-To: <20100923060703.GB11198@angua.secretlab.ca>
References: <20100920140049.31408.67527.stgit@localhost.localdomain>
	<20100920150431.GD31167@sirena.org.uk>
	<20100920152726.68ac2d84@linux.intel.com>
	<20100920152705.GJ3414@rakim.wolfsonmicro.main>
	<AANLkTi=1dkVOWc2WHhYgqKh_awUhp1-uKN8W7Xx3AB_X@mail.gmail.com>
	<20100922231514.5e9967c7@linux.intel.com>
	<20100923060703.GB11198@angua.secretlab.ca>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> any of this code could ever be made generic.  The spec seems to only
> cover the data structure, and relationships between devices seem to be
> left to whatever convention the firmware writer feels like using, or
> am I missing something?

Not really no. It's basically little more than a component and IRQ list.
The GPIO table in 0.8 exposes the GPIO lines a bit more sanely.

In fact all that SFI provides generically pretty much fits into
platform_foo() already because there is so little - or into the I²C or
SPI bus data.

Alan
