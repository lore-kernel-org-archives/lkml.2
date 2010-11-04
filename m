Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070Ab0KDOlO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 10:41:14 -0400
Received: from cantor.suse.de ([195.135.220.2]:38022 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475Ab0KDOlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 10:41:11 -0400
Date: Thu, 4 Nov 2010 10:41:10 -0400 (EDT)
From: Jiri Kosina <jkosina@suse.cz>
To: Chase Douglas <chase.douglas@canonical.com>
Cc: Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Philipp Merkel <mail@philmerk.de>, Stephane Chatty <chatty@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] hid: egalax: Use kzalloc
In-Reply-To: <1286991373.31864.193.camel@mini>
Message-ID: <alpine.LNX.2.00.1011041041010.15851@pobox.suse.cz>
References: <1286978302-30034-1-git-send-email-rydberg@euromail.se>  <1286978302-30034-2-git-send-email-rydberg@euromail.se> <1286991373.31864.193.camel@mini>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Oct 2010, Chase Douglas wrote:

> > To avoid unnecessary explicit initialization, allocate zeroed memory.
> > 
> > Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> > ---
> >  drivers/hid/hid-egalax.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/hid/hid-egalax.c b/drivers/hid/hid-egalax.c
> > index 54b017a..5a1b52e 100644
> > --- a/drivers/hid/hid-egalax.c
> > +++ b/drivers/hid/hid-egalax.c
> > @@ -221,7 +221,7 @@ static int egalax_probe(struct hid_device *hdev, const struct hid_device_id *id)
> >  	struct egalax_data *td;
> >  	struct hid_report *report;
> >  
> > -	td = kmalloc(sizeof(struct egalax_data), GFP_KERNEL);
> > +	td = kzalloc(sizeof(struct egalax_data), GFP_KERNEL);
> >  	if (!td) {
> >  		dev_err(&hdev->dev, "cannot allocate eGalax data\n");
> >  		return -ENOMEM;
> 
> Pretty obvious.
> 
> Acked-by: Chase Douglas <chase.douglas@canonical.com>

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
