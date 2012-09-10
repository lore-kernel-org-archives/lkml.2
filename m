Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758092Ab2IJSuA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 14:50:00 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:48733 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754347Ab2IJSt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 14:49:59 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/kGdHZMopGDeNJHUTCD3Bk
Date: Mon, 10 Sep 2012 11:49:55 -0700
From: Tony Lindgren <tony@atomide.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH 2/2] pinctrl: pinctrl-single: Add pinctrl-single,bits
 type of mux
Message-ID: <20120910184955.GB1303@atomide.com>
References: <1346835718-21325-1-git-send-email-peter.ujfalusi@ti.com>
 <1346835718-21325-3-git-send-email-peter.ujfalusi@ti.com>
 <CACRpkdbiCV4sKy2JAb6Yu5EuOVbfhq46yu5FRy7MXNT3QR6gaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbiCV4sKy2JAb6Yu5EuOVbfhq46yu5FRy7MXNT3QR6gaw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Walleij <linus.walleij@linaro.org> [120910 00:11]:
> On Wed, Sep 5, 2012 at 11:01 AM, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:
> 
> > With pinctrl-single,bits it is possible to update just part of the register
> > within the pinctrl-single,function-mask area.
> > This is useful when one register configures mmore than one pin's mux.
> >
> > pinctrl-single,bits takes three parameters:
> > <reg offset, value, sub-mask>
> >
> > Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> 
> Do we have a conclusion on this patch 2/2?
> 
> I'm holding it back until Tony explicitly ACKs it for now.

I don't like the idea of mixing different types of controllers
here, so let's wait a little bit on 2/2.

Tony
