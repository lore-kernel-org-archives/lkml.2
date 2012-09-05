Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758133Ab2IED4h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 23:56:37 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:18144 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab2IED4g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 23:56:36 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 04 Sep 2012 20:56:35 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "balbi@ti.com" <balbi@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Date: Wed, 5 Sep 2012 09:26:30 +0530
Subject: RE: [PATCH] usb: otg: Move phy interface to separate file.
Thread-Topic: [PATCH] usb: otg: Move phy interface to separate file.
Thread-Index: Ac2Kwc8Ma8T3kBNaRtehMhNrp8ttuwAV+2tQ
Message-ID: <D958900912E20642BCBC71664EFECE3E6DDE7751B3@BGMAIL02.nvidia.com>
References: <1346748958-10200-1-git-send-email-vbyravarasu@nvidia.com>
 <20120904172112.GA22494@kroah.com>
In-Reply-To: <20120904172112.GA22494@kroah.com>
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

Hi Greg,

Initially I pushed patch to linux-next with https://lkml.org/lkml/2012/8/29/40 .
In this patch, my mail id for "Signed-off-by" is correctly shown.

However as Felipe wanted me to push the patch to his branch, I synced to his code base and pushed the patch.
Am still not sure, why my mail id against signed-off-by got corrupted that way in this patch.

Please let me know if the patch is to be resent.

Thanks,
Venu


> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Tuesday, September 04, 2012 10:51 PM
> To: Venu Byravarasu
> Cc: balbi@ti.com; linux-kernel@vger.kernel.org; linux-usb@vger.kernel.org
> Subject: Re: [PATCH] usb: otg: Move phy interface to separate file.
> 
> On Tue, Sep 04, 2012 at 02:25:58PM +0530, Venu Byravarasu wrote:
> > As otg.h is containing lots of phy interface related
> > stuff, moving all phy interface related stuff to new
> > file named phy.h
> >
> > Signed-off-by: Venu Byravarasu <vbyravarasu@xxxxxxxxxx>
> 
> For some reason, I don't think that is a valid email address :(

