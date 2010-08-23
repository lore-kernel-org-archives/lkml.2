Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383Ab0HWGw0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 02:52:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:22758 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978Ab0HWGwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 02:52:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,256,1280732400"; 
   d="scan'208";a="650233117"
Date: Mon, 23 Aug 2010 14:52:17 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Tiago Maluta <tiago.maluta@gmail.com>, Michal Marek <mmarek@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH -mm V3] kbuild: fix reading CROSS_COMPILE from .config
Message-ID: <20100823065217.GA23924@localhost>
References: <20100821130749.GA22280@localhost>
 <20100823064530.GL5168@cr0.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100823064530.GL5168@cr0.nay.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think the line right above the chunk can be removed too, anyway,

Good catch!

> Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks,
Fengguang

