Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759436Ab2EINay (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 09:30:54 -0400
Received: from mga01.intel.com ([192.55.52.88]:2311 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759400Ab2EINaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 09:30:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="150973361"
Date: Wed, 9 May 2012 15:40:30 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: linux-kernel@vger.kernel.org, Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Alan Cox <alan@linux.intel.com>, grant.likely@secretlab.ca,
        linus.walleij@stericsson.com
Subject: Re: [PATCH V3 2/2] gpio: add STA2X11 GPIO block
Message-ID: <20120509134030.GC1794@sortiz-mobl>
References: <cover.1334219873.git.rubini@gnudd.com>
 <5e419c41c8e3bcbeac341aa9457a9c93bc4c8309.1334219874.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e419c41c8e3bcbeac341aa9457a9c93bc4c8309.1334219874.git.rubini@gnudd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alessandro,

On Thu, Apr 12, 2012 at 10:48:55AM +0200, Alessandro Rubini wrote:
> This introduces 128 gpio bits (for each PCI device installed) with
> working interrupt support.
I also applied this one, although I'd prefer to get Grant's ACK on it.
Grant could also apply it to his tree as the build time dependencies are
protected by the MFD_STA2X11 symbol.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
