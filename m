Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920Ab2KZVRP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 16:17:15 -0500
Received: from mga01.intel.com ([192.55.52.88]:19849 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753576Ab2KZVRO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 16:17:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,323,1352102400"; 
   d="scan'208";a="254506147"
From: "Keller, Jacob E" <jacob.e.keller@intel.com>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        Richard Cochran <richard.cochran@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: RE: [ 011/171] ptp: update adjfreq callback description
Thread-Topic: [ 011/171] ptp: update adjfreq callback description
Thread-Index: AQHNyEpLoIT7mVTlAkuExKks0ZzEPZf4qleAgAP7lMA=
Date: Mon, 26 Nov 2012 21:16:56 +0000
Message-ID: <02874ECE860811409154E81DA85FBB583AF35DD3@ORSMSX105.amr.corp.intel.com>
References: <20121122004033.298367941@linuxfoundation.org>
 <20121122004034.452636003@linuxfoundation.org>
 <20121124002654.GB12014@herton-Z68MA-D2H-B3>
In-Reply-To: <20121124002654.GB12014@herton-Z68MA-D2H-B3>
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
> From: Herton Ronaldo Krzesinski [mailto:herton.krzesinski@canonical.com]
> Sent: Friday, November 23, 2012 4:27 PM
> To: Greg Kroah-Hartman
> Cc: linux-kernel@vger.kernel.org; stable@vger.kernel.org;
> alan@lxorguk.ukuu.org.uk; Keller, Jacob E; Richard Cochran; John Stultz;
> Kirsher, Jeffrey T; David S. Miller
> Subject: Re: [ 011/171] ptp: update adjfreq callback description
> 
> On Wed, Nov 21, 2012 at 04:39:17PM -0800, Greg Kroah-Hartman wrote:
> > 3.4-stable review patch.  If anyone has any objections, please let me
> know.
> >
> > ------------------
> >
> > From: Jacob Keller <jacob.e.keller@intel.com>
> >
> > commit 87f4d7c1d36f44b0822053b7e5dedc31fdd0ab99 upstream.
> >
> > This patch updates the adjfreq callback description to include a note
> that the
> > delta in ppb is always relative to the base frequency, and not to the
> current
> > frequency of the hardware clock.
> >
> > Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> > CC: Richard Cochran <richard.cochran@gmail.com>
> > CC: John Stultz <john.stultz@linaro.org>
> > Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> > Signed-off-by: David S. Miller <davem@davemloft.net>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >
> > ---
> >  include/linux/ptp_clock_kernel.h |    3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > --- a/include/linux/ptp_clock_kernel.h
> > +++ b/include/linux/ptp_clock_kernel.h
> > @@ -50,7 +50,8 @@ struct ptp_clock_request {
> >   * clock operations
> >   *
> >   * @adjfreq:  Adjusts the frequency of the hardware clock.
> > - *            parameter delta: Desired period change in parts per
> billion.
> > + *            parameter delta: Desired frequency offset from nominal
> frequency
> > + *            in parts per billion
> >   *
> >   * @adjtime:  Shifts the time of the hardware clock.
> >   *            parameter delta: Desired change in nanoseconds.
> >
> 
> This was marked for only 3.5 or later on the original changelog:
> "CC: stable@vger.kernel.org [v3.5+]"
> 
> --
> []'s
> Herton

Originally didn't notice how far back PTP went.

-Jake
