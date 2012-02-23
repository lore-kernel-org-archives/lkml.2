Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653Ab2BWQfo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 11:35:44 -0500
Received: from mga11.intel.com ([192.55.52.93]:64130 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752177Ab2BWQfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 11:35:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="120580758"
Date: Thu, 23 Feb 2012 17:35:42 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mfd: Fix ACPI conflict check
Message-ID: <20120223163542.GM24377@sortiz-mobl>
References: <20120218175423.3f8d6ce6@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120218175423.3f8d6ce6@endymion.delvare>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

On Sat, Feb 18, 2012 at 05:54:23PM +0100, Jean Delvare wrote:
> The code is currently always checking the first resource of every
> device only (several times.) This has been broken since the ACPI check
> was added in February 2010 in commit
> 91fedede0338eb6203cdd618d8ece873fdb7c22c.
> 
> Fix the check to run on each resource individually, once.
Thanks for catching this one. Applied to both my for-next and for-linus
branches.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
