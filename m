Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181Ab1CQXNj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 19:13:39 -0400
Received: from mga11.intel.com ([192.55.52.93]:11839 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755555Ab1CQXNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 19:13:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,202,1299484800"; 
   d="scan'208";a="668491907"
Date: Fri, 18 Mar 2011 00:13:19 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Denis Turischev <denis@compulab.co.il>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [PATCH 3/3] sch_gpio: expand for Tunnel Creak
Message-ID: <20110317231319.GC32172@sortiz-mobl>
References: <4D7CE230.1070004@compulab.co.il>
 <4D7CE2BB.5010802@compulab.co.il>
 <4D7CE31E.207@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D7CE31E.207@compulab.co.il>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Denis,

On Sun, Mar 13, 2011 at 05:30:38PM +0200, Denis Turischev wrote:
> Almost the same driver for both Poulsbo and Tunnel Creek.
> The difference is in quantity of GPIOs powered by the core power
> rail and by suspend power supply, default values for some GPIOs, etc.
> Detect actual hardware by platform device ID assigned in lpc_sch
> and set configuration accordingly.
Thanks, patch applied with Grant's ACK.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
