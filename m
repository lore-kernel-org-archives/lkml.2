Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989Ab1CNU1s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 16:27:48 -0400
Received: from imr4.ericy.com ([198.24.6.8]:36940 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751245Ab1CNU1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 16:27:46 -0400
Date: Mon, 14 Mar 2011 13:27:17 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>
CC: Jonathan Cameron <jic23@cam.ac.uk>, Arnd Bergmann <arnd@arndb.de>,
        mems applications <mems.applications@st.com>,
        "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
        "carmine.iascone@st.com" <carmine.iascone@st.com>,
        "matteo.dameno@st.com" <matteo.dameno@st.com>,
        "rubini@ipvvis.unipv.it" <rubini@cvml.unipv.it>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add STMicroelectronics LPS001WP pressure sensor device
 driver into misc
Message-ID: <20110314202717.GA16461@ericsson.com>
References: <1300128906-1066-1-git-send-email-matteo.dameno@st.com>
 <4D7E6A38.7010801@cam.ac.uk>
 <201103142046.25393.arnd@arndb.de>
 <4D7E771B.1040804@cam.ac.uk>
 <20110314211809.29da8518@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110314211809.29da8518@endymion.delvare>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 14, 2011 at 04:18:09PM -0400, Jean Delvare wrote:
> On Mon, 14 Mar 2011 20:14:19 +0000, Jonathan Cameron wrote:
> > On 03/14/11 19:46, Arnd Bergmann wrote:
> > > On Monday 14 March 2011 20:19:20 Jonathan Cameron wrote:
> > >> The big issue raised last time around is that this is not a conventional human
> > >> input device.  Hence Dmitry isn't going to take it into input.  That doesn't
> > >> just mean that you have to move it's physical location; it also means you have
> > >> to not use the input interfaces at all.
> > > 
> > > How about making this a hwmon driver instead?
> > > There are already a number of temperature sensor drivers in
> > > driver/hwmon/, I think it would fit in well there.
> > hwmon are fairly forceful about not taking things that aren't for monitoring
> > hardware.  Even the humidity sensors in there are still controversial.
> > As it has been suggested I've cc'd Guenter and Jean just in case I'm wrong on
> > this.
> 
> Jonathan is correct. Pressure sensors are not hardware monitoring
> devices, their drivers have nothing to do in drivers/hwmon. This is
> something for drivers/misc or staging/iio.
> 

Absolutely agree.

Guenter

> > > This would mean moving it to the other directory,
> > > registering it to the common hwmon api (hwmon_device_register)
> > > and rewriting the user API to blend in with the other
> > > hwmon drivers.
> 
> -- 
> Jean Delvare
