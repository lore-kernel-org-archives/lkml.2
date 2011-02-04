Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751777Ab1BDHM4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 02:12:56 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57369 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060Ab1BDHMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 02:12:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Vl24ktTThRjwo8Oc7uuxDJpxlYzlW2uSBbJqmLi6Tx+OD/IchcS63Anl6/Q4PvvkXx
         zecDwZ8Nm/ySOXGcAzcdqiFVUYRZH7Xur537rsioQ0/8uHxk1QN1zTqNMEP8MsOJLIix
         Kre63xNVU5lE7GdK6kQ9HU6zgX3//Y/2yMEwU=
Date: Fri, 4 Feb 2011 10:12:50 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: rklein <rklein@nvidia.com>
Cc: "olofj@chromium.org" <olofj@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] power: bq20z75: add support for charge properties
Message-ID: <20110204071250.GA3360@oksana.dev.rtsoft.ru>
References: <1295982606-4604-1-git-send-email-rklein@nvidia.com>
 <20110131131952.GA22005@oksana.dev.rtsoft.ru>
 <1296775123.8295.5.camel@rklein-linux2>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1296775123.8295.5.camel@rklein-linux2>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 03, 2011 at 03:18:43PM -0800, rklein wrote:
> On Mon, 2011-01-31 at 05:19 -0800, Anton Vorontsov wrote:
> > On Tue, Jan 25, 2011 at 11:10:06AM -0800, rklein@nvidia.com wrote:
> > > From: Rhyland Klein <rklein@nvidia.com>
> > > 
> > > Adding support for charge properties for gas gauge.
> > > Also ensuring that battery mode is correct now for energy as well as
> > > charge properties by setting it on the fly.
> > > 
> > > I also added 2 functions to power_supply.h to help identify the units for
> > > specific properties more easily by power supplies.
> > > 
> > > Signed-off-by: Rhyland Klein <rklein@nvidia.com>
> > > ---
> > 
> > Applied with some cosmetic changes.
> > 
> > [...]
> > > +static inline bool power_supply_is_amp_property(
> > > +	enum power_supply_property psp){
> > 
> > Fixed style issues here.
> > 
> > [...]
> > > +static inline bool power_supply_is_watt_property(
> > > +	enum power_supply_property psp){
> > 
> > And here.
> > 
> > Thanks!
> > 
> 
> Anton, I looked at linux-next.git and battery-2.6.git but i don't see
> this latest version anywhere, is there a different git this was pushed
> to?

Hmm. I see it here:

http://git.infradead.org/battery-2.6.git/commitdiff/51d07566045787b99219d809639c8724506fc78a

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
