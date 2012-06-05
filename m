Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934253Ab2FENah (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 09:30:37 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:41707 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932429Ab2FENaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 09:30:35 -0400
Date: Tue, 5 Jun 2012 15:30:13 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: mkl@pengutronix.de
Cc: bhupesh.sharma@st.com, federico.vaga@gmail.com, alan@lxorguk.ukuu.org.uk,
        wg@grandegger.com, giancarlo.asnaghi@st.com, alan@linux.intel.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] c_can_pci: generic module for c_can on PCI
Message-ID: <20120605133013.GA16108@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <4FCE07EE.40003@pengutronix.de>
References: <4FCE07EE.40003@pengutronix.de>
  <D5ECB3C7A6F99444980976A8C6D896384FA5EC4DFC@EAPEX1MAIL1.st.com>
  <4FC135C6.5030206@grandegger.com> <1677842.Pq7naXsvrI@harkonnen>
  <D5ECB3C7A6F99444980976A8C6D896384FA5EC4B37@EAPEX1MAIL1.st.com>
  <3650428.HarNR9HfNF@harkonnen> <20120605131337.GA15432@mail.gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I personally like the "pci device sets up a platform device" idea.

Good. Than me or federico will submit a proposal. 
 
> My question is, is this considered being a good practise?

I don't think there are many pci bridges around, but platform drivers
exists just for that reason: to be instantiated when you know how the
wiring ("platform") details.  I.e., somebody registers the platform
device associated to the driver.

Sometimes the platform device is compiled in, sometimes it comes from
the device tree. I think it can come from PCI as well.

thanks
/alessandro, apologizing with Bhupesh Sharma for his tone in the previous mail
