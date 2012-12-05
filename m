Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962Ab2LEJwe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 04:52:34 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59019 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752731Ab2LEJwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 04:52:30 -0500
Date: Wed, 5 Dec 2012 10:52:25 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jean Delvare <khali@linux-fr.org>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        linux-input@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/14] HID: i2c-hid: change I2C name
In-Reply-To: <20121204170712.1bcdcddb@endymion.delvare>
Message-ID: <alpine.LNX.2.00.1212051052180.17055@pobox.suse.cz>
References: <1354634875-5182-1-git-send-email-benjamin.tissoires@gmail.com> <1354634875-5182-2-git-send-email-benjamin.tissoires@gmail.com> <20121204170712.1bcdcddb@endymion.delvare>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Dec 2012, Jean Delvare wrote:

> > no I2C driver has "i2c" in its name. It makes more sense to call this
> > i2c driver "hid".
> > 
> > Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
> > ---
> >  drivers/hid/i2c-hid/i2c-hid.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
> > index 67ab5b7..0fbb229 100644
> > --- a/drivers/hid/i2c-hid/i2c-hid.c
> > +++ b/drivers/hid/i2c-hid/i2c-hid.c
> > @@ -949,7 +949,7 @@ static int i2c_hid_resume(struct device *dev)
> >  static SIMPLE_DEV_PM_OPS(i2c_hid_pm, i2c_hid_suspend, i2c_hid_resume);
> >  
> >  static const struct i2c_device_id i2c_hid_id_table[] = {
> > -	{ "i2c_hid", 0 },
> > +	{ "hid", 0 },
> >  	{ },
> >  };
> >  MODULE_DEVICE_TABLE(i2c, i2c_hid_id_table);
> 
> Reviewed-by: Jean Delvare <khali@linux-fr.org>

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
