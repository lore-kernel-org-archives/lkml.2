Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab1CKUCX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 15:02:23 -0500
Received: from mga11.intel.com ([192.55.52.93]:22208 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113Ab1CKUCW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 15:02:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,304,1297065600"; 
   d="scan'208";a="666398324"
Date: Fri, 11 Mar 2011 21:02:21 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Andres Salomon <dilinger@queued.net>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] w1/ds1wm: silence warnings related to mfd_get_cell
 changes
Message-ID: <20110311200221.GB20247@sortiz-mobl>
References: <20110301135507.738d23c1@debxo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110301135507.738d23c1@debxo>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andres,

On Tue, Mar 01, 2011 at 01:55:07PM -0800, Andres Salomon wrote:
> 
> mfd_get_cell returns a const, so change the ds1wm client to store
> a const mfd cell.  This silences type mismatch warnings.
> 
> Since we're guaranteed to have the mfd_cell, we can also simplify
> the code a bit to get rid of a temporary variable and NULL check.
Patch applied, thanks a lot.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
