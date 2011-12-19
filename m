Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611Ab1LSRtA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 12:49:00 -0500
Received: from mga01.intel.com ([192.55.52.88]:8755 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032Ab1LSRs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 12:48:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="103879807"
Date: Mon, 19 Dec 2011 18:53:25 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: rabin.vincent@stericsson.com, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, armando.visconti@st.com,
        shiraz.hashim@st.com, vipin.kumar@st.com, rajeev-dlh.kumar@st.com,
        deepak.sikri@st.com, vipulkumar.samar@st.com, amit.virdi@st.com,
        pratyush.anand@st.com, bhupesh.sharma@st.com, viresh.linux@gmail.com,
        bhavna.yadav@st.com, vincenzo.frascino@st.com, mirko.gardi@st.com,
        grant.likely@secretlab.ca, linux-kernel@vger.kernel.org
Subject: Re: [PATVCH V3 Resend 5/5] gpio/gpio-stmpe: ADD support for stmpe
 variant 801
Message-ID: <20111219175325.GU11800@sortiz-mobl>
References: <cover.1321507421.git.viresh.kumar@st.com>
 <3acffb8a1da1ff69d70e745b23e8b79a859586c2.1321507421.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3acffb8a1da1ff69d70e745b23e8b79a859586c2.1321507421.git.viresh.kumar@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

On Wed, Dec 14, 2011 at 09:28:27AM +0530, Viresh Kumar wrote:
> STMPE801 is a GPIO expander. GPIO registers for 801 are slightly different from other
> variants. This patch adds support for STMPE801 in stmpe gpio driver.
> 
> Signed-off-by: Bhupesh Sharma <bhupesh.sharma@st.com>
> Signed-off-by: Pratyush Anand <pratyush.anand@st.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
> ---
> 
> Hi Samuel,
> 
> Please apply this patch instead of V2 5/5.
All 5 patches applied now, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
