Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575Ab1CNLpo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 07:45:44 -0400
Received: from mga11.intel.com ([192.55.52.93]:22048 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754213Ab1CNLpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 07:45:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,315,1297065600"; 
   d="scan'208";a="897012701"
Date: Mon, 14 Mar 2011 12:45:40 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Denis Turischev <denis@compulab.co.il>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [PATCH 3/3 v2] sch_gpio: expand for Tunnel Creek
Message-ID: <20110314114540.GO31153@sortiz-mobl>
References: <4D7CE230.1070004@compulab.co.il>
 <4D7CE2BB.5010802@compulab.co.il>
 <4D7CE31E.207@compulab.co.il>
 <4D7DF391.50302@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D7DF391.50302@compulab.co.il>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Denis,

On Mon, Mar 14, 2011 at 12:53:05PM +0200, Denis Turischev wrote:
> Almost the same driver for both Poulsbo and Tunnel Creek.
> The difference is in quantity of GPIOs powered by the core power
> rail and by suspend power supply, default values for some GPIOs, etc.
> Detect actual hardware by platform device ID assigned in lpc_sch
> and set configuration accordingly.
Grant, are you ok with me taking this patch ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
