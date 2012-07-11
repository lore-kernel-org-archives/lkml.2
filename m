Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029Ab2GKJ5s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 05:57:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:56413 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756984Ab2GKJ5q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 05:57:46 -0400
Message-ID: <1342000654.3462.137.camel@twins>
Subject: Re: [PATCH V2 5/5] perf/x86: Add Intel Nehalem-EX uncore support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: eranian@google.com, mingo@elte.hu, andi@firstfloor.org,
        linux-kernel@vger.kernel.org
Date: Wed, 11 Jul 2012 11:57:34 +0200
In-Reply-To: <4FFCDF8C.9060204@intel.com>
References: <1341381616-12229-1-git-send-email-zheng.z.yan@intel.com>
	   <1341381616-12229-6-git-send-email-zheng.z.yan@intel.com>
	  <1341396293.2507.77.camel@laptop> <4FF534F1.3030307@intel.com>
	 <1341922621.3462.130.camel@twins> <4FFCDF8C.9060204@intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-11 at 10:06 +0800, Yan, Zheng wrote:
> This doesn't work. The MSRs for Cbox 8/9 in WSM-EX aren't contiguous with
> Cbox 0~7.

Argh!

>  Furthermore the encoding for the FVC register in the Mbox are
> different between NHM-EX and WSM-EX.

OK, 18.7.1 from Vol. 3B doesn't mention that.. where did you find this?

> Please don't merge this patch, I will send a new one with WSM-EX support
> and some fixes soon. 

Found it in the inbox, thanks!
