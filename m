Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489Ab0H0P4o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 11:56:44 -0400
Received: from bsdimp.com ([199.45.160.85]:59996 "EHLO harmony.bsdimp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751597Ab0H0P4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 11:56:43 -0400
X-Greylist: delayed 982 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Aug 2010 11:56:42 EDT
Date: Fri, 27 Aug 2010 09:35:21 -0600 (MDT)
Message-Id: <20100827.093521.467748298504420477.imp@bsdimp.com>
To: richardcochran@gmail.com
Cc: alan@lxorguk.ukuu.org.uk, giometti@linux.it, johnstul@us.ibm.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        christian.riesch@omicron.at, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        khc@pm.waw.pl
Subject: Re: [PATCH 1/5] ptp: Added a brand new class driver for ptp clocks.
From: "M. Warner Losh" <imp@bsdimp.com>
In-Reply-To: <20100827140205.GA3293@riccoc20.at.omicron.at>
References: <20100827075727.GA3818@riccoc20.at.omicron.at>
	<20100827134154.50eef56c@lxorguk.ukuu.org.uk>
	<20100827140205.GA3293@riccoc20.at.omicron.at>
X-Mailer: Mew version 6.3 on Emacs 22.3 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message: <20100827140205.GA3293@riccoc20.at.omicron.at>
            Richard Cochran <richardcochran@gmail.com> writes:
: On Fri, Aug 27, 2010 at 01:41:54PM +0100, Alan Cox wrote:
: > > The master node in a PTP network probably takes its time from a
: > > precise external time source, like GPS. The GPS provides a 1 PPS
: > > directly to the PTP clock hardware, which latches the PTP hardware
: > > clock time on the PPS edge. This provides one sample as input to a
: > > clock servo (in the PTPd) that, in turn, regulates the PTP clock
: > > hardware.
: > 
: > A PTP clock is TAI, Unix time is UTC.
: 
: But TAI and UTC progress at the same rate, and UTC differs from TAI by
: a constant offset. In fact, the needed conversion is provided by the
: protocol, so it is not hard to take a 1 PPS from GPS and set the PTP
: clock to TAI.

Except for leap seconds, this is true.   However, Unix time isn't UTC
either.  Unix time is UTC that pretends leap seconds just don't
exist.  POSIX enshrined this long ago, and nobody is going to change
that any time soon.

I don't believe IEEEv2 propagates leap seconds, does it?

Warner
