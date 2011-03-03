Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758545Ab1CCRCD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 12:02:03 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:62820 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758519Ab1CCRCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 12:02:01 -0500
Date: Thu, 3 Mar 2011 10:01:57 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Jean Delvare <khali@linux-fr.org>
Cc: Wolfram Sang <w.sang@pengutronix.de>, Dirk Eibach <eibach@gdsys.de>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        rdunlap@xenotime.net, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] hwmon: (ads1015) Add devicetree documentation
Message-ID: <20110303170157.GA22940@angua.secretlab.ca>
References: <1299143805-13133-1-git-send-email-eibach@gdsys.de>
 <20110303115151.GF3649@pengutronix.de>
 <20110303132025.51e0d92e@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110303132025.51e0d92e@endymion.delvare>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 03, 2011 at 01:20:25PM +0100, Jean Delvare wrote:
> Hi Wolfram,
> 
> On Thu, 3 Mar 2011 12:51:51 +0100, Wolfram Sang wrote:
> > On Thu, Mar 03, 2011 at 10:16:45AM +0100, Dirk Eibach wrote:
> > > Signed-off-by: Dirk Eibach <eibach@gdsys.de>
> > > ---
> > >  Documentation/devicetree/bindings/i2c/ads1015.txt |   15 +++++++++++++++
> > >  1 files changed, 15 insertions(+), 0 deletions(-)
> > >  create mode 100644 Documentation/devicetree/bindings/i2c/ads1015.txt
> > > 
> > > diff --git a/Documentation/devicetree/bindings/i2c/ads1015.txt b/Documentation/devicetree/bindings/i2c/ads1015.txt
> > > new file mode 100644
> > > index 0000000..3a7d67a
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/i2c/ads1015.txt
> > > @@ -0,0 +1,15 @@
> > > +ADS1015 (I2C)
> > > +
> > > +Optional properties:
> > > +
> > > + - exported-channels : exported_channels is a bitmask that specifies which
> > > +		       inputs should be exported to sysfs.
> > 
> > Hmm, device tree bindings should be OS-neutral, sysfs is not.
> 
> Why do we document this in the Linux kernel tree then?

Lack of a better place and process for documenting and reviewing
bindings.  I've been toying with moving device tree bindings out to
devicetree.org, but I don't have a good review model for that.  I
might end up splitting it out into a separate git repository.

g.
