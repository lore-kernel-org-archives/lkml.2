Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321Ab1DFQUY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 12:20:24 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57644 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab1DFQUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 12:20:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rFHnjEG9gvnJ6AEosjfFarWo8879ZAMhjW7+3gN59/Rr9wmmiHVQhEh5m5zi0pP+mj
         9UbEyFRWmdaiBxLyAaxLaYWZiXMuWhQnRRI7vgGTd3OnE8KSlfuHa3g+gtXWAHiNjGkq
         L6Pvv6rP28Oj9PBUTsT9h+DVe8hpbhCtuIvMw=
Date: Wed, 6 Apr 2011 18:20:16 +0200
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Jean Delvare <khali@linux-fr.org>, Thomas Renninger <trenn@suse.de>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] hwmon: Add driver for AMD family 15h processor power
 information
Message-ID: <20110406162016.GF2177@alberich.amd.com>
References: <20110404160733.GA11818@alberich.amd.com>
 <20110405144536.GA5054@alberich.amd.com>
 <20110406161401.1c0ab6de@endymion.delvare>
 <20110406151901.GE2177@alberich.amd.com>
 <20110406173543.7308ba93@endymion.delvare>
 <20110406161445.GB25724@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110406161445.GB25724@ericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 06, 2011 at 09:14:45AM -0700, Guenter Roeck wrote:
> On Wed, Apr 06, 2011 at 11:35:43AM -0400, Jean Delvare wrote:
> > On Wed, 6 Apr 2011 17:19:01 +0200, Andreas Herrmann wrote:
> > > On Wed, Apr 06, 2011 at 04:14:01PM +0200, Jean Delvare wrote:
> > > > On Tue, 5 Apr 2011 16:45:36 +0200, Andreas Herrmann wrote:
> > > > > +static ssize_t show_power(struct device *dev,
> > > > > +			  struct device_attribute *attr, char *buf)
> > > > > +{
> > > > > +	u32 val, btdp, tdpl, tdp2w, arange;
> > > > > +	s32 acap;
> > > > > +	u64 ctdp;
> > > > 
> > > > These variable names aren't easy to understand.
> > > 
> > > Just random names which eventually map to the spec:
> > > 
> > > btdp - base_tdp
> > > tdpl - tdp_limit
> > > tdp2w - tdp_to_watt
> > > acap - average_accumulator_capture (or even worse how about "processor_tdp_running_average_accumulator":(
> > > arange - average_range
> > 
> > avg_cap and avg_range would do, respectively, for the last two.
> > 
> > > I don't think that changing the names make it much easier to
> > > reconstruct the calculation but if you insist in changing it I'll
> > > adapt it.
> > 
> > I do prefer the "extended" names, really. Sure, this doesn't change the
> > calculations, but it helps the reader understand what's going on. Which
> > will be useful if one ever has to fix a bug in the code or extend it
> > for a different CPU family.
> > 
> > But maybe this is just me. Guenter, do you have an opinion?
> > 
> I agree. base_tdp is definitely much better than btdp. Same for the others.
> 
> Thanks,
> Guenter

Ok.

Will update the patch soon.


Andreas
