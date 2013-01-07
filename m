Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851Ab3AGOY3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 09:24:29 -0500
Received: from mga01.intel.com ([192.55.52.88]:38144 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754799Ab3AGOYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 09:24:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,424,1355126400"; 
   d="scan'208";a="273801014"
Date: Mon, 7 Jan 2013 06:00:12 -0800
From: Vinod Koul <vinod.koul@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: linux-next: build failure after merge of the slave-dma tree
Message-ID: <20130107140012.GG18119@intel.com>
References: <20130107112637.71699f7daefcccc9ab94d5cf@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130107112637.71699f7daefcccc9ab94d5cf@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2013 at 11:26:37AM +1100, Stephen Rothwell wrote:
> After merging the slave-dma tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
Hi Stephen,

I rebased the tree last night and messed up at two places. Viresh helped to fix
one. I have pushed the fixed tree now. My limited build test looks fine now

--
~Vinod
