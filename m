Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215Ab1KNAHR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 19:07:17 -0500
Received: from mga11.intel.com ([192.55.52.93]:10437 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752130Ab1KNAHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 19:07:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,504,1315206000"; 
   d="scan'208";a="84713356"
Date: Mon, 14 Nov 2011 01:11:15 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: rabin.vincent@stericsson.com, linus.walleij@stericsson.com,
        linux-kernel@vger.kernel.org, armando.visconti@st.com,
        shiraz.hashim@st.com, vipin.kumar@st.com, rajeev-dlh.kumar@st.com,
        deepak.sikri@st.com, vipulkumar.samar@st.com, amit.virdi@st.com,
        pratyush.anand@st.com, bhupesh.sharma@st.com, viresh.linux@gmail.com,
        bhavna.yadav@st.com, vincenzo.frascino@st.com, mirko.gardi@st.com,
        srinidhi.kasagar@stericsson.com
Subject: Re: [PATCH V2] mfd/stmpe: Add support for irq over gpio pin
Message-ID: <20111114001115.GD22218@sortiz-mobl>
References: <3f04cea36ee4180f65da8f766c06d5fd0b0e61d8.1320725434.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f04cea36ee4180f65da8f766c06d5fd0b0e61d8.1320725434.git.viresh.kumar@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

On Tue, Nov 08, 2011 at 09:44:06AM +0530, Viresh Kumar wrote:
> On many boards, stmpe is present as an separate device (not as part of SoC).
> Here gpio lines are mostly used for getting interrupts. This patch adds in
> support to handle irq over gpio pin.
Thanks, applied to my for-next branch.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
