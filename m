Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758078Ab0JSVtm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 17:49:42 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:28221 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165Ab0JSVtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 17:49:41 -0400
Date: Tue, 19 Oct 2010 23:49:29 +0200
From: Jean Delvare <khali@linux-fr.org>
To: guenter.roeck@ericsson.com
Cc: Ben Dooks <ben-linux@fluff.org>, Rodolfo Giometti <giometti@linux.it>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] i2c/mux: Driver for PCA9541 I2C Master Selector
Message-ID: <20101019234929.3d4d14f4@endymion.delvare>
In-Reply-To: <1287521453.9690.299.camel@groeck-laptop>
References: <1286932516-20689-1-git-send-email-guenter.roeck@ericsson.com>
	<20101019190647.314302e7@endymion.delvare>
	<1287521453.9690.299.camel@groeck-laptop>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Oct 2010 13:50:53 -0700, Guenter Roeck wrote:
> Hi Jean,
> 
> On Tue, 2010-10-19 at 13:06 -0400, Jean Delvare wrote:
> [ ... ]
> > > +
> > > +/*
> > > + * I2C init/probing/exit functions
> > > + */
> > > +static int __devinit pca9541_probe(struct i2c_client *client,
> > > +                                const struct i2c_device_id *id)
> > 
> > The use of __devinit and __devexit isn't recommended for i2c drivers.
> > If your driver is built into the kernel but the underlying i2c bus
> > driver is build as a module, you're in trouble.
> > 
> I don't mind changing this, but ... the code is copied from pca954x.c,
> which also uses __devinit and __devexit for the same functions. Wouldn't
> that be a problem there as well ? Or am I missing something ?

You're right, this should be fixed. I take patches ;)

-- 
Jean Delvare
