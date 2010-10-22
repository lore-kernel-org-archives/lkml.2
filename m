Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757160Ab0JVOWB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 10:22:01 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:32941 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754278Ab0JVOWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 10:22:00 -0400
Date: Fri, 22 Oct 2010 15:20:24 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Cyril Chemparathy <cyril@ti.com>
Cc: davinci-linux-open-source@linux.davincidsp.com,
        spi-devel-general@lists.sourceforge.net,
        broonie@opensource.wolfsonmicro.com, lrg@slimlogic.co.uk,
        dbrownell@users.sourceforge.net, grant.likely@secretlab.ca,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        rpurdie@rpsys.net
Subject: Re: [PATCH v3 01/12] misc: add driver for sequencer serial port
Message-ID: <20101022152024.65e8f181@lxorguk.ukuu.org.uk>
In-Reply-To: <1287694873-12904-2-git-send-email-cyril@ti.com>
References: <1287694873-12904-1-git-send-email-cyril@ti.com>
	<1287694873-12904-2-git-send-email-cyril@ti.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Oct 2010 17:01:02 -0400
Cyril Chemparathy <cyril@ti.com> wrote:

> TI's sequencer serial port (TI-SSP) is a jack-of-all-trades type of serial port
> device.  It has a built-in programmable execution engine that can be programmed
> to operate as almost any serial bus (I2C, SPI, EasyScale, and others).
> 
> This patch adds a driver for this controller device.  The driver does not
> expose a user-land interface.  Protocol drivers built on top of this layer are
> expected to remain in-kernel.

I suspect the driver belongs with the mfd drivers not with drivers/misc ?

otherwise it looks very nice.
