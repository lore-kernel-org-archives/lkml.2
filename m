Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493Ab2BFQWm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 11:22:42 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:55071 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755147Ab2BFQWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 11:22:41 -0500
Date: Mon, 6 Feb 2012 16:24:09 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: cbou@mail.ru, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add I2C driver for Summit Microelectronics SMB347
 Battery Charger.
Message-ID: <20120206162409.4f7536cf@pyramind.ukuu.org.uk>
In-Reply-To: <20120206160127.GF10173@sirena.org.uk>
References: <20120206155729.9947.22792.stgit@bob.linux.org.uk>
	<20120206160127.GF10173@sirena.org.uk>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Feb 2012 16:01:27 +0000
Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> On Mon, Feb 06, 2012 at 03:59:01PM +0000, Alan Cox wrote:
> 
> > Driver support for the Summit I??C battery charger. This is used in some
> > Intel devices.
> 
> There's quite a lot of read/modify/write cycles and...

True but they are basically all in the setup side of things so I'm not
sure the complexity is justified or appropriate ?

Agreed on module_i2c_driver() - I'll do a follow on patch to switch it to
that.

Alan
