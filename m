Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779Ab2HPQ5W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 12:57:22 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:34419 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754719Ab2HPQ5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 12:57:05 -0400
X-Sasl-enc: f6+2UAKa3cnJOz/+6LYnQWdJqk8+TSpheCjjmvLutdpv 1345136224
Date: Thu, 16 Aug 2012 09:57:03 -0700
From: GregKH <greg@kroah.com>
To: Daniel Mack <zonque@gmail.com>
Cc: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>,
        Evgeniy Polyakov <zbr@ioremap.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] onewire: w1-gpio: add ext_pullup_enable pin in
 platform data
Message-ID: <20120816165703.GA8746@kroah.com>
References: <1343249670-14985-1-git-send-email-zonque@gmail.com>
 <20120730181238.GA23443@ioremap.net>
 <20120731005929.GP27847@sci.fi>
 <501778DA.5020107@gmail.com>
 <20120801165736.GQ27847@sci.fi>
 <501E9CB9.8080902@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <501E9CB9.8080902@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 05, 2012 at 06:18:01PM +0200, Daniel Mack wrote:
> On 01.08.2012 18:57, Ville Syrjälä wrote:
> > On Tue, Jul 31, 2012 at 08:19:06AM +0200, Daniel Mack wrote:
> >> On 31.07.2012 02:59, Ville Syrjälä wrote:
> >>> On Mon, Jul 30, 2012 at 10:12:39PM +0400, Evgeniy Polyakov wrote:
> >>>> Hi
> >>>>
> >>>> Sorry for long delay
> >>>> [resend with fixed Greg's address :)]
> >>>>
> >>>> On Wed, Jul 25, 2012 at 10:54:29PM +0200, Daniel Mack (zonque@gmail.com) wrote:
> >>>>> In the process of porting boards to devicetree implemenation, we should
> >>>>> keep information about external circuitry where they belong - the
> >>>>> individual drivers.
> >>>>>
> >>>>> This patch adds a way to specify a GPIO to drive the (optional) external
> >>>>> pull-up logic, rather than using a function pointer for that.
> >>>>
> >>>> I do not object against this patch, but I have rather limited knowledge
> >>>> about gpio driver. Patch looks good, feel free to add my
> >>>> Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
> >>>>
> >>>> Greg, please pull it into your tree, if Ville does not object.
> >>>
> >>> No objections from me.
> >>
> >> I take this as an Acked-by:?
> > 
> > Sure, why not :)
> > 
> > Acked-by: Ville Syrjälä <syrjala@sci.fi>
> > 
> 
> Greg, could you queue up these two patches somewhere?

Yes, I now have them, thanks.

greg k-h
