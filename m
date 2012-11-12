Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015Ab2KLDJv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 22:09:51 -0500
Received: from mga09.intel.com ([134.134.136.24]:24487 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751262Ab2KLDJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 22:09:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,759,1344236400"; 
   d="scan'208";a="240459034"
Date: Sun, 11 Nov 2012 19:17:26 -0800 (PST)
From: Joseph Gasparakis <joseph.gasparakis@intel.com>
X-X-Sender: jgaspara@morpheus.jf.intel.com
To: David Miller <davem@davemloft.net>
cc: joseph.gasparakis@intel.com, shemminger@vyatta.com, chrisw@sous-sol.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        peter.p.waskiewicz.jr@intel.com
Subject: Re: [PATCH v2 3/3] ipgre: capture inner headers during
 encapsulation
In-Reply-To: <20121111.220652.1964621381859974031.davem@davemloft.net>
Message-ID: <alpine.LFD.2.02.1211111916500.5009@morpheus.jf.intel.com>
References: <1352689450-4092-1-git-send-email-joseph.gasparakis@intel.com> <20121111.220652.1964621381859974031.davem@davemloft.net>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
ReplyTo: "Joseph Gasparakis" <joseph.gasparakis@intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 11 Nov 2012, David Miller wrote:

> 
> Please post the entire series again when making updates to any of
> the patches, thank you.
> 
Will do. Thanks Dave.
