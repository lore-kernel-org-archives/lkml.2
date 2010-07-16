Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935803Ab0GPHSy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 03:18:54 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51346 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935760Ab0GPHSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 03:18:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LMBhRdSB+uz2SVQeZi8DVdK+ZafomDBYuxT6e3KfbIRmmoz0bozY4phhh8cs0+hwfo
         XvptYh62o6pHpIZ/wb2F97AEsb8ymn159e91W/XCDJ+TLo7Iy2QigoZK+6/PP47mRtq1
         wmzqRp6MCQF+9iatLWvc9uqnlusCGRNb60mgo=
Date: Fri, 16 Jul 2010 00:18:44 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Kulikov Vasiliy <segooon@gmail.com>, kernel-janitors@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>, Luotao Fu <l.fu@pengutronix.de>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] touchscreen: fix sign bug
Message-ID: <20100716071844.GD3712@core.coreip.homeip.net>
References: <1279219435-12128-1-git-send-email-segooon@gmail.com>
 <20100715204927.GA4627@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100715204927.GA4627@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 15, 2010 at 10:49:27PM +0200, Luotao Fu wrote:
> On Thu, Jul 15, 2010 at 10:43:54PM +0400, Kulikov Vasiliy wrote:
> > platform_get_irq_byname() can return negative results, it is not seen to
> > unsigned ts_irq. Make it signed.
> > 
> > Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
> 
> Acked-By: Luotao Fu <l.fu@pengutronix.de>
> 

OK, the driver is still in Samuel's tree so he gets to pick the patch...

Thanks.

-- 
Dmitry
