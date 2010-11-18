Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968Ab0KRG1y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 01:27:54 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:54623 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab0KRG1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 01:27:53 -0500
Date: Thu, 18 Nov 2010 15:27:15 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Shaohui Zheng <shaohui.zheng@intel.com>
Cc: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
        ak@linux.intel.com, shaohui.zheng@linux.intel.com,
        Yinghai Lu <yinghai@kernel.org>, Haicheng Li <haicheng.li@intel.com>
Subject: Re: [2/8,v3] NUMA Hotplug Emulator: infrastructure of NUMA hotplug emulation
Message-ID: <20101118062715.GD17539@linux-sh.org>
References: <20101117020759.016741414@intel.com> <20101117021000.568681101@intel.com> <alpine.DEB.2.00.1011162359160.17408@chino.kir.corp.google.com> <20101117075128.GA30254@shaohui> <alpine.DEB.2.00.1011171304060.10254@chino.kir.corp.google.com> <20101118041407.GA2408@shaohui>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101118041407.GA2408@shaohui>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 12:14:07PM +0800, Shaohui Zheng wrote:
> On Wed, Nov 17, 2010 at 01:10:50PM -0800, David Rientjes wrote:
> > The idea that I've proposed (and you've apparently thought about and even 
> > implemented at one point) is much more powerful than that.  We need not 
> > query the state of hidden nodes that we've setup at boot but can rather 
> > use the amount of hidden memory to setup the nodes in any way that we want 
> > at runtime (various sizes, interleaved node ids, etc).
> 
> yes, if we select your proposal. we just mark all the nodes as POSSIBLE node.
> there is no hidden nodes any more. the node will be created after add memory
> to the node first time. 
> 
This is roughly what I had in mind in my N_HIDDEN review, so I quite
favour this approach.
