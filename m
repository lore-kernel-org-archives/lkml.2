Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141Ab1CQXNC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 19:13:02 -0400
Received: from mga09.intel.com ([134.134.136.24]:15540 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755522Ab1CQXM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 19:12:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,202,1299484800"; 
   d="scan'208";a="721380691"
Date: Fri, 18 Mar 2011 00:12:33 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Denis Turischev <denis@compulab.co.il>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [PATCH 2/3] lpc_sch: expand for Tunnel Creek
Message-ID: <20110317231232.GB32172@sortiz-mobl>
References: <4D7CE230.1070004@compulab.co.il>
 <4D7CE2BB.5010802@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D7CE2BB.5010802@compulab.co.il>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Denis,

On Sun, Mar 13, 2011 at 05:28:59PM +0200, Denis Turischev wrote:
> Intel Poulsbo SCH and Tunnel Creek provide almost the
> same LPC interface. Use the same driver for both devices while
> storing PCI ID to distinguish between platforms to apply plarform
> related quirks.
Thanks, patch applied.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
