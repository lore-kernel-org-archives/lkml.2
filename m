Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289Ab1K2Jzf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 04:55:35 -0500
Received: from mga01.intel.com ([192.55.52.88]:61763 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753026Ab1K2Jze (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 04:55:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,590,1315206000"; 
   d="scan'208";a="96447254"
Date: Tue, 29 Nov 2011 10:59:54 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Donggeun Kim <dg77.kim@samsung.com>, linux-kernel@vger.kernel.org,
        broonie@opensource.wolfsonmicro.com, gregkh@suse.de,
        kyungmin.park@samsung.com, myungjoo.ham@samsung.com
Subject: Re: [PATCH 2/2] misc: add driver support for MAX8997 MUIC
Message-ID: <20111129095954.GP5443@sortiz-mobl>
References: <1322125938-6944-2-git-send-email-dg77.kim@samsung.com>
 <1322125938-6944-3-git-send-email-dg77.kim@samsung.com>
 <20111128154801.05f7c199.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111128154801.05f7c199.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Mon, Nov 28, 2011 at 03:48:01PM -0800, Andrew Morton wrote:
> On Thu, 24 Nov 2011 18:12:18 +0900
> Donggeun Kim <dg77.kim@samsung.com> wrote:
> 
> > The MUIC function in MAX8997 device can be used as
> > a USB port detector and switch.
> > This patch supports the MUIC feature of MAX8997.
> > 
> > Signed-off-by: Donggeun Kim <dg77.kim@samsung.com>
> > Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> 
> Samuel, can you please merge this if/when it's ready?

I will take it once I review it, yes.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
