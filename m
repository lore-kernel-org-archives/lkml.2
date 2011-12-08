Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415Ab1LHOmO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 09:42:14 -0500
Received: from mga09.intel.com ([134.134.136.24]:10272 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750804Ab1LHOmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 09:42:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="84314069"
Date: Thu, 8 Dec 2011 16:42:21 +0200
From: Heikki Krogerus <krohei@gmail.com>
To: Felipe Contreras <felipe.contreras@nokia.com>
Cc: linux-kernel@vger.kernel.org, Kalle Jokiniemi <kalle.jokiniemi@nokia.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: Re: [PATCH 1/2] isp1704_charger: fix missing check
Message-ID: <20111208144221.GB25415@xps8300>
References: <1323105820-25946-1-git-send-email-felipe.contreras@nokia.com>
 <1323105820-25946-2-git-send-email-felipe.contreras@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323105820-25946-2-git-send-email-felipe.contreras@nokia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 05, 2011 at 07:23:39PM +0200, Felipe Contreras wrote:
> From: Felipe Contreras <felipe.contreras@gmail.com>
> 
> A segfault happens if there's no board information.
> 
> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>

Acked-by: Heikki Krogerus <krohei@gmail.com>

-- 
heikki
