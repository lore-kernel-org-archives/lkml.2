Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211Ab1LATFB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 14:05:01 -0500
Received: from mga14.intel.com ([143.182.124.37]:2300 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755850Ab1LATE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 14:04:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,279,1320652800"; 
   d="scan'208";a="43006722"
Date: Thu, 1 Dec 2011 20:09:41 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Joe Perches <joe@perches.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] nfc: Use standard logging styles
Message-ID: <20111201190941.GJ22609@sortiz-mobl>
References: <cover.1322595343.git.joe@perches.com>
 <6c89a76ddb76926febe36fe5be514cb186e39a76.1322595343.git.joe@perches.com>
 <20111201155951.GF22609@sortiz-mobl>
 <1322765318.30801.9.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322765318.30801.9.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On Thu, Dec 01, 2011 at 10:48:38AM -0800, Joe Perches wrote:
> > I would be fine with moving to pr_debug, but I'd like the pr_fmt() routine to
> > include the function name as well.
> 
> If you really want it I can add it back but
> if you are not aware, dynamic debug can add
> this by using:
> 
> echo "module nfc +fp" > <debugfs>/dynamic_debug/control
> echo "module nci +fp" > <debugfs>/dynamic_debug/control
Yes, I'm aware of that.

 
> If you're getting dmesg logs from customers
> that's a bit harder to track though.
Exactly. I'd prefer to have the __func__ being part of the pr_fmt().

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
