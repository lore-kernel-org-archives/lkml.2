Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932427Ab1KOVQO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 16:16:14 -0500
Received: from imr3.ericy.com ([198.24.6.13]:37648 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932307Ab1KOVQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 16:16:12 -0500
Subject: Re: [PATCH] i2c/busses: (mpc) Add support for SMBUS_READ_BLOCK_DATA
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: Jean Delvare <khali@linux-fr.org>
CC: Tabi Timur-B04825 <B04825@freescale.com>, Ben Dooks <ben-linux@fluff.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tang Yuantian-B29983 <B29983@freescale.com>
In-Reply-To: <20111115210528.0f9a0948@endymion.delvare>
References: <1321338462-6138-1-git-send-email-guenter.roeck@ericsson.com>
	 <20111115095445.3d34e99e@endymion.delvare>
	 <CAOZdJXVq=0pbrPM_-+Kjf3NhON8oN3Me64R6c9qBiAEFuRsDOw@mail.gmail.com>
	 <1321384487.2309.363.camel@groeck-laptop>
	 <20111115210528.0f9a0948@endymion.delvare>
Content-Type: text/plain; charset="UTF-8"
Organization: Ericsson
Date: Tue, 15 Nov 2011 13:14:40 -0800
Message-ID: <1321391680.2309.374.camel@groeck-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-15 at 15:05 -0500, Jean Delvare wrote:
> On Tue, 15 Nov 2011 11:14:47 -0800, Guenter Roeck wrote:
> > On Tue, 2011-11-15 at 14:02 -0500, Tabi Timur-B04825 wrote:
> > > I think it's very important to keep the order as-is, if at all
> > > possible.  This driver is very old and the hardware is used on all of
> > > our SOCs, dating back several years.  It would be a nightmare to test
> > > it all over again.
> >
> > I'll see if I can work around that. 1-byte block reads may be tricky,
> > though, but maybe I can get that working as well.
> 
> IMHO it's OK if 1-byte blocks are not supported. In practice the length
> of blocks seems to be known in advance and it's never 1. We can revisit
> if this is ever needed in practice for this specific bus driver.
> 
I think I have a workaround for that condition. The workaround will only
apply if the length is 1, so the risk associated with it is low. I'll
test it and let you know if it works.

Guenter


