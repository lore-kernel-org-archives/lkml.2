Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781Ab2KUOSh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 09:18:37 -0500
Received: from mga11.intel.com ([192.55.52.93]:35249 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754596Ab2KUOSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 09:18:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,293,1352102400"; 
   d="scan'208";a="252396639"
Date: Wed, 21 Nov 2012 15:18:33 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Vipul Kumar Samar <vipulkumar.samar@st.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 2/2] mfd: stmpe: Add DT support in stmpe driver
Message-ID: <20121121141833.GW18738@sortiz-mobl>
References: <07672d0597e23fbc580843193415b89e81dba326.1352475033.git.viresh.kumar@linaro.org>
 <52354a3da05aca599f47ad06c1b291ebc4f87c84.1352475033.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52354a3da05aca599f47ad06c1b291ebc4f87c84.1352475033.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

On Fri, Nov 09, 2012 at 09:01:55PM +0530, Viresh Kumar wrote:
> From: Vipul Kumar Samar <vipulkumar.samar@st.com>
> 
> This patch adds support to probe stmpe devices via DT. Bindings are mentioned in
> binding document.
> 
> Signed-off-by: Vipul Kumar Samar <vipulkumar.samar@st.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  Documentation/devicetree/bindings/mfd/stmpe.txt | 121 +++++++++++
>  drivers/mfd/stmpe-i2c.c                         |  23 ++-
>  drivers/mfd/stmpe-spi.c                         |  15 ++
>  drivers/mfd/stmpe.c                             | 264 +++++++++++++++++++++++-
>  4 files changed, 418 insertions(+), 5 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/mfd/stmpe.txt
Lee Jones (cc'ed) submitted a patch for the same purpose, see commit 909582ca from my
for-next branch.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
