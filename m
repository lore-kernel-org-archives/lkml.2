Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126Ab1J1GfI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 02:35:08 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:7452 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730Ab1J1GfG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 02:35:06 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 27 Oct 2011 23:35:02 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, "pavel@ucw.cz" <pavel@ucw.cz>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Date: Fri, 28 Oct 2011 12:04:58 +0530
Subject: RE: [PATCH] PM: fix calculation mistake in roll-over cases
Thread-Topic: [PATCH] PM: fix calculation mistake in roll-over cases
Thread-Index: AcyU1noOcpC2klRaRzu21/zWYgmcrQAZPd4g
Message-ID: <D958900912E20642BCBC71664EFECE3E6D123A0B41@BGMAIL02.nvidia.com>
References: <D958900912E20642BCBC71664EFECE3E6D123A0AFF@BGMAIL02.nvidia.com>
 <Pine.LNX.4.44L0.1110271426100.2004-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1110271426100.2004-100000@iolanthe.rowland.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Alan Stern [mailto:stern@rowland.harvard.edu]
> Sent: Friday, October 28, 2011 12:00 AM
> To: Venu Byravarasu
> Cc: Rafael J. Wysocki; pavel@ucw.cz; len.brown@intel.com; gregkh@suse.de;
> linux-pm@vger.kernel.org; linux-kernel@vger.kernel.org; Peter De Schrijver
> Subject: RE: [PATCH] PM: fix calculation mistake in roll-over cases
> 
> On Thu, 27 Oct 2011, Venu Byravarasu wrote:
> 
> > > From: venu byravarasu <vbyravarasu@nvidia.com>
> > >
> > > In case of jiffies roll over, delta is made zero.
> > > Hence fixing it, after taking roll over into consideration.
> > >
> > > Signed-off-by: venu byravarasu <vbyravarasu@nvidia.com>
> > > ---
> 
> > 2. Even if delta is made unsigned, in cases of jiffies roll over, delta will be zero.
> > That is also being taken care with the code added as part of if condition.
> 
> Since delta is now unsigned, the "if (delta < 0)" test can never
> succeed.  Therefore it can be removed.
> 
> The new lines you added with max_num don't seem to serve any useful
> purpose.  All they do is recalculate the same value that delta had
> before, but with an off-by-one error.
> 
Agree with you Alan.
Will remove max_num references and upload the change.

Thanks,
Venu
