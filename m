Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700Ab0LIBsF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 20:48:05 -0500
Received: from mga02.intel.com ([134.134.136.20]:53258 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755043Ab0LIBsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 20:48:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,318,1288594800"; 
   d="scan'208";a="581956399"
Date: Thu, 9 Dec 2010 08:23:02 +0800
From: Shaohui Zheng <shaohui.zheng@intel.com>
To: David Rientjes <rientjes@google.com>
Cc: Eric B Munson <emunson@mgebm.net>,
        Shaohui Zheng <shaohui.zheng@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
        lethal@linux-sh.org, Andi Kleen <ak@linux.intel.com>,
        dave@linux.vnet.ibm.com, Greg Kroah-Hartman <gregkh@suse.de>,
        Haicheng Li <haicheng.li@intel.com>
Subject: Re: [1/7,v8] NUMA Hotplug Emulator: documentation
Message-ID: <20101209002302.GB5798@shaohui>
References: <20101207010033.280301752@intel.com>
 <20101207010139.681125359@intel.com>
 <20101207182420.GA2038@mgebm.net>
 <20101207232000.GA5353@shaohui>
 <20101208181644.GA2152@mgebm.net>
 <alpine.DEB.2.00.1012081315040.15658@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1012081315040.15658@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 08, 2010 at 01:16:10PM -0800, David Rientjes wrote:
> On Wed, 8 Dec 2010, Eric B Munson wrote:
> 
> > Shaohui,
> > 
> > I was able to online a cpu to node 0 successfully.  My problem was that I did
> > not take the cpu offline before I released it.  Everything looks to be working
> > for me.
> > 
> 
> I think it should fail more gracefully than triggering WARN_ON()s because 
> of duplicate sysfs dentries though, right?

Yes, we should do more checking on the return value, the duplicate dentries can
be avoided.  

Another solution: force user to offline the cpu before we do cpu release.

-- 
Thanks & Regards,
Shaohui

