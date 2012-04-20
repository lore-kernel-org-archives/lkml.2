Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336Ab2DTNWe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 09:22:34 -0400
Received: from smtp.nokia.com ([147.243.128.24]:33805 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752421Ab2DTNWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 09:22:33 -0400
Message-ID: <1334928095.2851.11.camel@groo>
Subject: Re: [PATCH 6/6] HSI: Add HSI ABI documentation
From: Carlos Chinea <carlos.chinea@nokia.com>
To: ext Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, linus.walleij@linaro.org,
        artem.bityutskiy@linux.intel.com, shubhrajyoti@ti.com
Date: Fri, 20 Apr 2012 16:21:35 +0300
In-Reply-To: <20120419151703.GB31543@kroah.com>
References: <1334837127-12931-1-git-send-email-carlos.chinea@nokia.com>
	 <1334837127-12931-7-git-send-email-carlos.chinea@nokia.com>
	 <20120419151703.GB31543@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-04-19 at 08:17 -0700, ext Greg KH wrote:
> On Thu, Apr 19, 2012 at 03:05:27PM +0300, Carlos Chinea wrote:
> > Adds sysfs HSI framework documentation
> > 
> > Signed-off-by: Carlos Chinea <carlos.chinea@nokia.com>
> > ---
> >  Documentation/ABI/testing/sysfs-bus-hsi |   19 +++++++++++++++++++
> >  1 files changed, 19 insertions(+), 0 deletions(-)
> >  create mode 100644 Documentation/ABI/testing/sysfs-bus-hsi
> > 
> > diff --git a/Documentation/ABI/testing/sysfs-bus-hsi b/Documentation/ABI/testing/sysfs-bus-hsi
> > new file mode 100644
> > index 0000000..1b1b282
> > --- /dev/null
> > +++ b/Documentation/ABI/testing/sysfs-bus-hsi
> > @@ -0,0 +1,19 @@
> > +What:		/sys/bus/hsi
> > +Date:		April 2012
> > +KernelVersion:	3.4
> > +Contact:	Carlos Chinea <carlos.chinea@nokia.com>
> > +Description:
> > +		High Speed Synchronous Serial Interface (HSI) is a
> > +		serial interface mainly used for connecting application
> > +		engines (APE) with cellular modem engines (CMT) in cellular
> > +		handsets.
> > +		The bus will be populated with devices (hsi_clients) representing
> > +		the protocols available in the system. Bus drivers implement
> > +		those protocols.
> > +
> > +What:		/sys/bus/hsi/devices/.../modalias
> > +Date:		April 2012
> > +KernelVersion:	3.4
> > +Contact:	Carlos Chinea <carlos.chinea@nokia.com>
> > +Description:	Stores the same MODALIAS value emitted by uevent
> > +		Format: hsi:<hsi_client device name>
> 
> You don't have any files in the device directories at all that you
> create other than the modalias one?  If so, that's fine, just curious.
> 

yes that's case, only the modalias one is created.

Br,
Carlos



