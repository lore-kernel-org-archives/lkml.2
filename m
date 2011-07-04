Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758207Ab1GDRjK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 13:39:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:62315 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755907Ab1GDRjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 13:39:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,474,1304319600"; 
   d="scan'208";a="26160806"
Date: Mon, 4 Jul 2011 19:39:35 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: =?iso-8859-1?Q?P=E9ter?= Ujfalusi <peter.ujfalusi@ti.com>
Cc: "Girdwood, Liam" <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "Lopez Cruz, Misael" <misael.lopez@ti.com>
Subject: Re: Re: [PATCH v6 08/18] mfd: twl6040: Add initial support
Message-ID: <20110704173935.GT3021@sortiz-mobl>
References: <1308663556-29120-1-git-send-email-peter.ujfalusi@ti.com>
 <1308663556-29120-9-git-send-email-peter.ujfalusi@ti.com>
 <20110704114844.GA3021@sortiz-mobl>
 <1650114.SY7VdjHPHs@barack>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1650114.SY7VdjHPHs@barack>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Mon, Jul 04, 2011 at 05:08:17PM +0300, Péter Ujfalusi wrote:
> Hi Samuel,
> 
> On Monday 04 July 2011 13:48:44 Samuel Ortiz wrote:
> > I don't see the value of those 3 inline functions. Removing them would make
> > the code actually more understandable (especially for the 2nd one).
> 
> Is it OK for you if I fix these as a follow-up series, so I do not need to 
> rewrite this series, and resend it?
That is fine with me, yes. That's why I ACK the MFD patches for Tony to take
them.
Thanks in advance for the follow up patches.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
