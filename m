Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab1DSQ6h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 12:58:37 -0400
Received: from mga03.intel.com ([143.182.124.21]:26453 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752081Ab1DSQ6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 12:58:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,240,1301900400"; 
   d="scan'208";a="421988416"
Date: Tue, 19 Apr 2011 09:58:01 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Ozan =?utf-8?B?w4dhxJ9sYXlhbg==?= <ozan@pardus.org.tr>
Cc: stable@kernel.org, giridhar.malavali@qlogic.com, James.Bottomley@suse.de,
        linux-kernel@vger.kernel.org, andrew.vasquez@qlogic.com
Subject: Re: [BISECTED] QLogic Corp. ISP2532-based 8Gb Fibre Channel not
 working on 2.6.35.y
Message-ID: <20110419165801.GA17788@tassilo.jf.intel.com>
References: <4DAD5495.5060704@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DAD5495.5060704@pardus.org.tr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From 2f0f3f4f06f7cfadebf58b70bd9e7f71d8fd96e4 Mon Sep 17 00:00:00 2001
> From: Madhuranath Iyengar <madhuranath.iyengar@qlogic.com>
> Date: Fri, 23 Jul 2010 15:28:24 +0500
> Subject: [PATCH 021/107] [SCSI] qla2xxx: Appropriately log FCP
> priority data messages
> 
> Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
> Signed-off-by: James Bottomley <James.Bottomley@suse.de>
> 
> 
> -------
> 
> So I think at least the first commit that I've mentioned should be
> queued for the next 2.6.35.y to fix this issue.

Thanks for the bisection.

Can I get an ack for that from the driver or SCSI maintainer or
patch author first please?
I don't understand the driver well enough to make a call myself.

Thanks,

-Andi
