Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933016Ab0KLXMj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 18:12:39 -0500
Received: from imr3.ericy.com ([198.24.6.13]:59721 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932584Ab0KLXMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 18:12:38 -0500
Subject: Re: [lm-sensors] Location for thermal drivers
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Phil Pokorny <ppokorny@penguincomputing.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
In-Reply-To: <20101112223938.4f2675d7@lxorguk.ukuu.org.uk>
References: <1289594026.22931.388.camel@groeck-laptop>
	 <AANLkTimERGh2yGGX_E_N4ajxg_-0QTFS54QSKj2+AAfF@mail.gmail.com>
	 <1289599600.22931.406.camel@groeck-laptop>
	 <20101112223938.4f2675d7@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
Organization: Ericsson
Date: Fri, 12 Nov 2010 15:11:55 -0800
Message-ID: <1289603515.20815.6.camel@groeck-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-12 at 17:39 -0500, Alan Cox wrote:
> > > Why does drivers/thermal exist if there are no drivers in it and no maintainer?
> 
> It has a maintainer - they are just not listed in MAINTAINERS only in the
> file itself.
> 
> > > 
> > The framework resides there. Drivers supporting it are in various
> > platform directories.
> > 
> > As for why there are no drivers - only the framework - in
> > drivers/thermal, and why there is no maintainer - no idea.
> 
> Well I could put it in arch/x86/platform/mrst now we have that structure
> from 2.6.37-rc1 onwards

I thought the driver is for Medfield ? Is that the same ? Or do you mean
you would add platform/medfield ? That might be another option.

Then there is drivers/platform/x86/intel_menlow.c, which has the thermal
driver code for Menlow.

Guenter


