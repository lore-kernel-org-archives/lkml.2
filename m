Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab2LEJz4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 04:55:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59204 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948Ab2LEJzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 04:55:53 -0500
Date: Wed, 5 Dec 2012 10:55:50 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jean Delvare <khali@linux-fr.org>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        linux-input@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/14] HID: i2c-hid: fix checkpatch.pl warning
In-Reply-To: <20121204224349.2cefa121@endymion.delvare>
Message-ID: <alpine.LNX.2.00.1212051055440.17055@pobox.suse.cz>
References: <1354634875-5182-1-git-send-email-benjamin.tissoires@gmail.com> <1354634875-5182-5-git-send-email-benjamin.tissoires@gmail.com> <20121204224349.2cefa121@endymion.delvare>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Dec 2012, Jean Delvare wrote:

> > We should not initialize to 0 static declarations.
> > 
> > Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
> > ---
> >  drivers/hid/i2c-hid/i2c-hid.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
> > index ad771a7..9ee6555 100644
> > --- a/drivers/hid/i2c-hid/i2c-hid.c
> > +++ b/drivers/hid/i2c-hid/i2c-hid.c
> > @@ -46,7 +46,7 @@
> >  #define I2C_HID_PWR_SLEEP	0x01
> >  
> >  /* debug option */
> > -static bool debug = false;
> > +static bool debug;
> >  module_param(debug, bool, 0444);
> >  MODULE_PARM_DESC(debug, "print a lot of debug information");
> >  
> 
> Reviewed-by: Jean Delvare <khali@linux-fr.org>

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
