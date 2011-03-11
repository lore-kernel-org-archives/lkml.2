Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275Ab1CKUhb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 15:37:31 -0500
Received: from mga02.intel.com ([134.134.136.20]:26926 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752920Ab1CKUh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 15:37:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,305,1297065600"; 
   d="scan'208";a="719239116"
Date: Fri, 11 Mar 2011 21:37:08 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Andres Salomon <dilinger@queued.net>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd-core: rename mfd_shared_cell_{en,dis}able to drop
 the "shared" part
Message-ID: <20110311203707.GD20247@sortiz-mobl>
References: <20110303095158.6b5fc39b@debxo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110303095158.6b5fc39b@debxo>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andres,

On Thu, Mar 03, 2011 at 09:51:58AM -0800, Andres Salomon wrote:
> 
> As requested by Samuel, there's not really any reason to have "shared"
> in the name.
> 
> This also modifies the only user of the function, as well.
Thanks for following up on this one, patch applied now.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
