Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507Ab1CRWyd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 18:54:33 -0400
Received: from gate.crashing.org ([63.228.1.57]:45071 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752488Ab1CRWy3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 18:54:29 -0400
Subject: Re: RFC: Platform data for onboard USB assets
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: andy.green@linaro.org
Cc: Greg KH <greg@kroah.com>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <4D830CEC.4040608@linaro.org>
References: <20110311165642.GA9996@kroah.com>
	 <20110317214042.GQ31411@opensource.wolfsonmicro.com>
	 <20110317214736.GA29014@kroah.com> <201103172333.01474.arnd@arndb.de>
	 <20110317225328.GB31581@kroah.com> <4D8296D1.9060106@linaro.org>
	 <20110317232503.GA14561@kroah.com>  <4D830CEC.4040608@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 19 Mar 2011 09:54:09 +1100
Message-ID: <1300488849.22236.1296.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-18 at 07:42 +0000, Andy Green wrote:
> 
> No, if you read Arnd's post you will find Device Tree does not support 
> targeting USB devices yet, and if you further read the 1998 document he 
> points to as the basis of actually implementing it, it seems to me at 
> least it'll be a little project yet to do that on Linux side.

You are getting seriously full of sh*t here. Read again what Arnd said
rather than twisting it to try to make your point.

The age of the OF binding document for USB has no relevance. The fact
that it's a very simple binding however does. As Arnd mention, nobody
says that somebody/something has to generate a full and complete
representation of USB for your board, that would be beyond the scope.

However, it should be trivial to layout in the fixed part of the board
device-tree nodes representing on-board (fixed) devices with the right
amount of properties for allowing the linkage to happen between those
nodes and the Linux usb_device object.

Basically it boils down to one property afaik, "reg". That's about it
(oh and possibly #address-cells and compatible for hubs that are on the
way to the device if any). About 15mn of work if you are familiar with
the .dts syntax, maybe twice as much if you are not.  

Cheers,
Ben.


