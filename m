Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395Ab2KURAj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 12:00:39 -0500
Received: from mga11.intel.com ([192.55.52.93]:52295 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755335Ab2KURAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 12:00:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,293,1352102400"; 
   d="scan'208";a="250630920"
Date: Wed, 21 Nov 2012 18:00:21 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: "Patil, Rachna" <rachna@ti.com>
Cc: "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        Rob Landley <rob@landley.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: [PATCH RESEND 0/7] MFD: ti_am335x_tscadc: DT support and TSC
 features addition
Message-ID: <20121121170021.GE18738@sortiz-mobl>
References: <1352271124-5513-1-git-send-email-rachna@ti.com>
 <4CE347531D4CA947960AF71FF095B9323E96C54A@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE347531D4CA947960AF71FF095B9323E96C54A@DBDE01.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rachna,

On Fri, Nov 16, 2012 at 10:33:00AM +0000, Patil, Rachna wrote:
> Hi,
> 
> This is just a gentle reminder of the patch set I had posted earlier viz.
> "[PATCH RESEND 0/7] MFD: ti_am335x_tscadc: DT support and TSC features addition"
> Can this patch set be pulled in if there are no review comments.
> This patch set does not break anything existing, it just adds new features and DT support for the MFD core and its clients.
I'm fine with the MFD part, but did you get Dmitry's ACK on the input ones ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
