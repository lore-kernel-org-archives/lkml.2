Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757083Ab2KZVTU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 16:19:20 -0500
Received: from mga14.intel.com ([143.182.124.37]:61459 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756716Ab2KZVTT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 16:19:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,323,1352102400"; 
   d="scan'208";a="222591737"
From: "Keller, Jacob E" <jacob.e.keller@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        Richard Cochran <richard.cochran@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: RE: [ 05/38] ptp: update adjfreq callback description
Thread-Topic: [ 05/38] ptp: update adjfreq callback description
Thread-Index: AQHNyEoLc2w11YFAH0WYPflw1Wf1GZf4qheAgARYCwD//6R3QA==
Date: Mon, 26 Nov 2012 21:19:07 +0000
Message-ID: <02874ECE860811409154E81DA85FBB583AF35E1D@ORSMSX105.amr.corp.intel.com>
References: <20121122003904.262382971@linuxfoundation.org>
 <20121122003904.841717525@linuxfoundation.org>
 <20121124002600.GA12014@herton-Z68MA-D2H-B3>
 <20121126184610.GC21012@kroah.com>
In-Reply-To: <20121126184610.GC21012@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Greg Kroah-Hartman [mailto:gregkh@linuxfoundation.org]
> Sent: Monday, November 26, 2012 10:46 AM
> To: Herton Ronaldo Krzesinski
> Cc: linux-kernel@vger.kernel.org; stable@vger.kernel.org;
> alan@lxorguk.ukuu.org.uk; Keller, Jacob E; Richard Cochran; John Stultz;
> Kirsher, Jeffrey T; David S. Miller
> Subject: Re: [ 05/38] ptp: update adjfreq callback description
> 
> On Fri, Nov 23, 2012 at 10:26:01PM -0200, Herton Ronaldo Krzesinski wrote:
> > On Wed, Nov 21, 2012 at 04:39:48PM -0800, Greg Kroah-Hartman wrote:
> > > 3.0-stable review patch.  If anyone has any objections, please let me
> know.
> > >
> > > ------------------
> > >
> > > From: Jacob Keller <jacob.e.keller@intel.com>
> > >
> > > commit 87f4d7c1d36f44b0822053b7e5dedc31fdd0ab99 upstream.
> > >
> > > This patch updates the adjfreq callback description to include a note
> that the
> > > delta in ppb is always relative to the base frequency, and not to the
> current
> > > frequency of the hardware clock.
> > >
> > > Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> > > CC: Richard Cochran <richard.cochran@gmail.com>
> > > CC: John Stultz <john.stultz@linaro.org>
> > > Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> > > Signed-off-by: David S. Miller <davem@davemloft.net>
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > >
> > > ---
> > >  include/linux/ptp_clock_kernel.h |    3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > >
> > > --- a/include/linux/ptp_clock_kernel.h
> > > +++ b/include/linux/ptp_clock_kernel.h
> > > @@ -50,7 +50,8 @@ struct ptp_clock_request {
> > >   * clock operations
> > >   *
> > >   * @adjfreq:  Adjusts the frequency of the hardware clock.
> > > - *            parameter delta: Desired period change in parts per
> billion.
> > > + *            parameter delta: Desired frequency offset from nominal
> frequency
> > > + *            in parts per billion
> > >   *
> > >   * @adjtime:  Shifts the time of the hardware clock.
> > >   *            parameter delta: Desired change in nanoseconds.
> >
> > This was marked for only 3.5 or later on the original changelog:
> > "CC: stable@vger.kernel.org [v3.5+]"
> 
> Ugh, my fault, now dropped from the 3.0 and 3.4-stable trees, thanks for
> finding my error.
> 
> thanks,
> 
> greg k-h

It seems to me that it should be applied back to 3.0 if PTP is there..

- Jake
