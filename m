Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113Ab2GaBH2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 21:07:28 -0400
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:42225 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab2GaBH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 21:07:27 -0400
X-Greylist: delayed 469 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Jul 2012 21:07:27 EDT
Date: Tue, 31 Jul 2012 03:59:29 +0300
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Daniel Mack <zonque@gmail.com>, linux-kernel@vger.kernel.org,
        GregKH <greg@kroah.com>
Subject: Re: [PATCH 1/2] onewire: w1-gpio: add ext_pullup_enable pin in
 platform data
Message-ID: <20120731005929.GP27847@sci.fi>
Mail-Followup-To: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>,
	Evgeniy Polyakov <zbr@ioremap.net>, Daniel Mack <zonque@gmail.com>,
	linux-kernel@vger.kernel.org, GregKH <greg@kroah.com>
References: <1343249670-14985-1-git-send-email-zonque@gmail.com>
 <20120730181238.GA23443@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120730181238.GA23443@ioremap.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2012 at 10:12:39PM +0400, Evgeniy Polyakov wrote:
> Hi
> 
> Sorry for long delay
> [resend with fixed Greg's address :)]
> 
> On Wed, Jul 25, 2012 at 10:54:29PM +0200, Daniel Mack (zonque@gmail.com) wrote:
> > In the process of porting boards to devicetree implemenation, we should
> > keep information about external circuitry where they belong - the
> > individual drivers.
> > 
> > This patch adds a way to specify a GPIO to drive the (optional) external
> > pull-up logic, rather than using a function pointer for that.
> 
> I do not object against this patch, but I have rather limited knowledge
> about gpio driver. Patch looks good, feel free to add my
> Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
> 
> Greg, please pull it into your tree, if Ville does not object.

No objections from me.

The only cosmetic issue I spotted was 'pdata' being assigned twice in
w1_gpio_probe().

-- 
Ville Syrjälä
syrjala@sci.fi
http://www.sci.fi/~syrjala/
