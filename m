Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751336Ab1BDSYi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 13:24:38 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:3155 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab1BDSYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 13:24:37 -0500
X-PGP-Universal: processed;
	by hqnvupgp04.nvidia.com on Fri, 04 Feb 2011 10:24:34 -0800
Subject: Re: [PATCH v3] power: bq20z75: add support for charge properties
From: rklein <rklein@nvidia.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: "olofj@chromium.org" <olofj@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20110204071250.GA3360@oksana.dev.rtsoft.ru>
References: <1295982606-4604-1-git-send-email-rklein@nvidia.com>
	 <20110131131952.GA22005@oksana.dev.rtsoft.ru>
	 <1296775123.8295.5.camel@rklein-linux2>
	 <20110204071250.GA3360@oksana.dev.rtsoft.ru>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Feb 2011 10:24:10 -0800
Message-ID: <1296843850.16497.0.camel@rklein-linux2>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-03 at 23:12 -0800, Anton Vorontsov wrote:
> On Thu, Feb 03, 2011 at 03:18:43PM -0800, rklein wrote:
> > On Mon, 2011-01-31 at 05:19 -0800, Anton Vorontsov wrote:
> > > On Tue, Jan 25, 2011 at 11:10:06AM -0800, rklein@nvidia.com wrote:
> > > > From: Rhyland Klein <rklein@nvidia.com>
> > > > 
> > > > Adding support for charge properties for gas gauge.
> > > > Also ensuring that battery mode is correct now for energy as well as
> > > > charge properties by setting it on the fly.
> > > > 
> > > > I also added 2 functions to power_supply.h to help identify the units for
> > > > specific properties more easily by power supplies.
> > > > 
> > > > Signed-off-by: Rhyland Klein <rklein@nvidia.com>
> > > > ---
> > > 
> > > Applied with some cosmetic changes.
> > > 
> > > [...]
> > > > +static inline bool power_supply_is_amp_property(
> > > > +	enum power_supply_property psp){
> > > 
> > > Fixed style issues here.
> > > 
> > > [...]
> > > > +static inline bool power_supply_is_watt_property(
> > > > +	enum power_supply_property psp){
> > > 
> > > And here.
> > > 
> > > Thanks!
> > > 
> > 
> > Anton, I looked at linux-next.git and battery-2.6.git but i don't see
> > this latest version anywhere, is there a different git this was pushed
> > to?
> 
> Hmm. I see it here:
> 
> http://git.infradead.org/battery-2.6.git/commitdiff/51d07566045787b99219d809639c8724506fc78a
> 
> Thanks,
> 

Hmm, i see it now, thanks!

