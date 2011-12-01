Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab1LAPzL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 10:55:11 -0500
Received: from mga03.intel.com ([143.182.124.21]:50443 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755124Ab1LAPzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 10:55:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,278,1320652800"; 
   d="scan'208";a="42938077"
Date: Thu, 1 Dec 2011 16:59:51 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Joe Perches <joe@perches.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] nfc: Use standard logging styles
Message-ID: <20111201155951.GF22609@sortiz-mobl>
References: <cover.1322595343.git.joe@perches.com>
 <6c89a76ddb76926febe36fe5be514cb186e39a76.1322595343.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c89a76ddb76926febe36fe5be514cb186e39a76.1322595343.git.joe@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On Tue, Nov 29, 2011 at 11:37:32AM -0800, Joe Perches wrote:
> Using the normal logging styles is preferred over
> subsystem specific styles when the subsystem does
> not take a specific struct.
> 
> Convert nfc_<level> specific messages to pr_<level>
> Add newlines to uses.
> 
I would be fine with moving to pr_debug, but I'd like the pr_fmt() routine to
include the function name as well.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
