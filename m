Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958Ab2HAQ5n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 12:57:43 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:35579 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab2HAQ5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 12:57:42 -0400
Date: Wed, 1 Aug 2012 19:57:36 +0300
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>
To: Daniel Mack <zonque@gmail.com>
Cc: Evgeniy Polyakov <zbr@ioremap.net>, linux-kernel@vger.kernel.org,
        GregKH <greg@kroah.com>
Subject: Re: [PATCH 1/2] onewire: w1-gpio: add ext_pullup_enable pin in
 platform data
Message-ID: <20120801165736.GQ27847@sci.fi>
Mail-Followup-To: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>,
	Daniel Mack <zonque@gmail.com>, Evgeniy Polyakov <zbr@ioremap.net>,
	linux-kernel@vger.kernel.org, GregKH <greg@kroah.com>
References: <1343249670-14985-1-git-send-email-zonque@gmail.com>
 <20120730181238.GA23443@ioremap.net>
 <20120731005929.GP27847@sci.fi>
 <501778DA.5020107@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <501778DA.5020107@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 08:19:06AM +0200, Daniel Mack wrote:
> On 31.07.2012 02:59, Ville Syrjälä wrote:
> > On Mon, Jul 30, 2012 at 10:12:39PM +0400, Evgeniy Polyakov wrote:
> >> Hi
> >>
> >> Sorry for long delay
> >> [resend with fixed Greg's address :)]
> >>
> >> On Wed, Jul 25, 2012 at 10:54:29PM +0200, Daniel Mack (zonque@gmail.com) wrote:
> >>> In the process of porting boards to devicetree implemenation, we should
> >>> keep information about external circuitry where they belong - the
> >>> individual drivers.
> >>>
> >>> This patch adds a way to specify a GPIO to drive the (optional) external
> >>> pull-up logic, rather than using a function pointer for that.
> >>
> >> I do not object against this patch, but I have rather limited knowledge
> >> about gpio driver. Patch looks good, feel free to add my
> >> Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
> >>
> >> Greg, please pull it into your tree, if Ville does not object.
> > 
> > No objections from me.
> 
> I take this as an Acked-by:?

Sure, why not :)

Acked-by: Ville Syrjälä <syrjala@sci.fi>

-- 
Ville Syrjälä
syrjala@sci.fi
http://www.sci.fi/~syrjala/
