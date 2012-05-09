Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759413Ab2EIN2E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 09:28:04 -0400
Received: from mga01.intel.com ([192.55.52.88]:19752 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759353Ab2EIN2C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 09:28:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="163945794"
Date: Wed, 9 May 2012 15:37:40 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: linux-kernel@vger.kernel.org, Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Alan Cox <alan@linux.intel.com>, grant.likely@secretlab.ca,
        linus.walleij@stericsson.com
Subject: Re: [PATCH V3 1/2] mfd: Add driver for STA2X11 MFD block
Message-ID: <20120509133740.GB1794@sortiz-mobl>
References: <cover.1334219873.git.rubini@gnudd.com>
 <99e873520a5e9278abfaaf9fbd514bab2c326479.1334219874.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <99e873520a5e9278abfaaf9fbd514bab2c326479.1334219874.git.rubini@gnudd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alessandro,

On Thu, Apr 12, 2012 at 10:48:44AM +0200, Alessandro Rubini wrote:
> This also introduces <asm/sta2x11.h> to export a function that is in
> the base sta2x11 support patches. The header will increase with other
> prototypes and constants over time.
I applied this one, after removing the GPIO_STA2X11 selection from the Kconfig
entry, and after protecting bar0_cells and bar1_cells namespace with a STA2X11
prefix.
Please have a look at it and let me know if there are some issues with it.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
