Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605Ab0JSUvX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 16:51:23 -0400
Received: from imr3.ericy.com ([198.24.6.13]:36442 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757576Ab0JSUvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 16:51:20 -0400
Subject: Re: [PATCH v2] i2c/mux: Driver for PCA9541 I2C Master Selector
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: Jean Delvare <khali@linux-fr.org>
CC: Ben Dooks <ben-linux@fluff.org>, Rodolfo Giometti <giometti@linux.it>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20101019190647.314302e7@endymion.delvare>
References: <1286932516-20689-1-git-send-email-guenter.roeck@ericsson.com>
	 <20101019190647.314302e7@endymion.delvare>
Content-Type: text/plain; charset="UTF-8"
Organization: Ericsson
Date: Tue, 19 Oct 2010 13:50:53 -0700
Message-ID: <1287521453.9690.299.camel@groeck-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

On Tue, 2010-10-19 at 13:06 -0400, Jean Delvare wrote:
[ ... ]
> > +
> > +/*
> > + * I2C init/probing/exit functions
> > + */
> > +static int __devinit pca9541_probe(struct i2c_client *client,
> > +                                const struct i2c_device_id *id)
> 
> The use of __devinit and __devexit isn't recommended for i2c drivers.
> If your driver is built into the kernel but the underlying i2c bus
> driver is build as a module, you're in trouble.
> 
I don't mind changing this, but ... the code is copied from pca954x.c,
which also uses __devinit and __devexit for the same functions. Wouldn't
that be a problem there as well ? Or am I missing something ?

Thanks,
Guenter

 



