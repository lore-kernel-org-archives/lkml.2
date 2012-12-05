Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801Ab2LEJzS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 04:55:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59149 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948Ab2LEJzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 04:55:15 -0500
Date: Wed, 5 Dec 2012 10:55:10 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jean Delvare <khali@linux-fr.org>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        linux-input@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/14] HID: i2c-hid: enhance Kconfig
In-Reply-To: <20121204224302.2846b007@endymion.delvare>
Message-ID: <alpine.LNX.2.00.1212051055040.17055@pobox.suse.cz>
References: <1354634875-5182-1-git-send-email-benjamin.tissoires@gmail.com> <1354634875-5182-4-git-send-email-benjamin.tissoires@gmail.com> <20121204224302.2846b007@endymion.delvare>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Dec 2012, Jean Delvare wrote:

> > The "comment" part can never be displayed, so we can remove it.
> > 
> > Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
> > ---
> >  drivers/hid/i2c-hid/Kconfig | 7 ++-----
> >  1 file changed, 2 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/hid/i2c-hid/Kconfig b/drivers/hid/i2c-hid/Kconfig
> > index 5b7d4d8..64ce108 100644
> > --- a/drivers/hid/i2c-hid/Kconfig
> > +++ b/drivers/hid/i2c-hid/Kconfig
> > @@ -7,15 +7,12 @@ config I2C_HID
> >  	depends on I2C && INPUT
> >  	select HID
> >  	---help---
> > -	  Say Y here if you want to use the HID over i2c protocol
> > -	  implementation.
> > +	  Say Y here if you use a keyboard, a touchpad, a touchscreen, or any
> > +	  other HID based devices which is connected to your computer via I2C.
> >  
> >  	  If unsure, say N.
> >  
> >  	  This support is also available as a module.  If so, the module
> >  	  will be called i2c-hid.
> >  
> > -comment "Input core support is needed for HID over I2C input layer"
> > -	depends on I2C_HID && INPUT=n
> > -
> >  endmenu
> 
> Reviewed-by: Jean Delvare <khali@linux-fr.org>

Applied.

-- 
Jiri Kosina
SUSE Labs
