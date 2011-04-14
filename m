Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759483Ab1DNUC0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 16:02:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57554 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759462Ab1DNUCL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 16:02:11 -0400
Date: Thu, 14 Apr 2011 12:58:42 -0700
From: Greg KH <gregkh@suse.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Bill Gatliff <bgat@billgatliff.com>, linux-kernel@vger.kernel.org,
        linux-embedded@vger.kernel.org, Wolfram Sang <w.sang@pengutronix.de>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PWM v9 1/3] PWM: Implement a generic PWM framework
Message-ID: <20110414195842.GA18872@suse.de>
References: <1301630392-20793-1-git-send-email-bgat@billgatliff.com>
 <1301630392-20793-2-git-send-email-bgat@billgatliff.com>
 <BANLkTi=1Nh+EcZw_U6U8ZS2yVyqmCtuAcQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=1Nh+EcZw_U6U8ZS2yVyqmCtuAcQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 01:49:27PM -0600, Grant Likely wrote:
> > +static struct class pwm_class = {
> > +       .name           = "pwm",
> > +       .owner          = THIS_MODULE,
> > +       .dev_attrs      = pwm_dev_attrs,
> > +};
> 
> >From my understanding, class is deprecated.  I believe you should be
> using bus_type directly now.  Check with Greg and Kay.

Yes, that is correct, please don't create new classes if at all
possible.  And this code looks like it is fine to use a bus_type.

thanks,

greg k-h
