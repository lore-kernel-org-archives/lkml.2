Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933234Ab2JDNs2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 09:48:28 -0400
Received: from mga03.intel.com ([143.182.124.21]:26220 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933049Ab2JDNs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 09:48:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,535,1344236400"; 
   d="scan'208";a="200520722"
Date: Thu, 4 Oct 2012 15:48:22 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Ulf Hansson <ulf.hansson@stericsson.com>
Cc: linux-arm-kernel@lists.infradead.org, Mike Turquette <mturquette@ti.com>,
        Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Philippe Begnic <philippe.begnic@st.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH 1/3] mfd: dbx500: Export prmcu_request_ape_opp_100_voltage
Message-ID: <20121004134822.GA5567@sortiz-mobl>
References: <1348497799-32143-1-git-send-email-ulf.hansson@stericsson.com>
 <1348497799-32143-2-git-send-email-ulf.hansson@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348497799-32143-2-git-send-email-ulf.hansson@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ulf,

On Mon, Sep 24, 2012 at 04:43:17PM +0200, Ulf Hansson wrote:
> From: Ulf Hansson <ulf.hansson@linaro.org>
> 
> This function needs to be exported to let clients be able to
> request the ape opp 100 voltage.
> 
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
