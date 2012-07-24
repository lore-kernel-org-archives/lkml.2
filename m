Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab2GXHzD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 03:55:03 -0400
Received: from mga11.intel.com ([192.55.52.93]:6397 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755084Ab2GXHzB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 03:55:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="197235572"
Date: Tue, 24 Jul 2012 15:54:59 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: rajman mekaco <rajman.mekaco@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [QUERY]: Understanding the calculations in mm/page-writeback.c
Message-ID: <20120724075459.GB9519@localhost>
References: <CAMYGaxpusZsvVYdruSe4cYr9FWsAs2Eu-7tpoUJoU_GyL1QmXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMYGaxpusZsvVYdruSe4cYr9FWsAs2Eu-7tpoUJoU_GyL1QmXA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rajman,

On Sun, Jul 22, 2012 at 09:18:57PM +0530, rajman mekaco wrote:
> Hi,
> 
> I am trying to understand the calculations in mm/page-writeback.c but
> I am falling short of theoretical knowledge.
> 
> What online (or otherwise) reading material can be used to fully
> understand the maths formulae in mm/page-writeback.c ?

Here is the slides I used in LinuxCon Japan 2012, please feel free to
ask more specific questions on it :)

http://events.linuxfoundation.org/images/stories/pdf/lcjp2012_wu.pdf

Thanks,
Fengguang
