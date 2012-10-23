Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932988Ab2JWNNK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 09:13:10 -0400
Received: from mga03.intel.com ([143.182.124.21]:32368 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932337Ab2JWNNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 09:13:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,635,1344236400"; 
   d="scan'208";a="207949279"
Date: Tue, 23 Oct 2012 21:13:04 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [CPU hotplug, cpuidle_disable_device] BUG: unable to handle
 kernel NULL pointer dereference at (null)
Message-ID: <20121023131304.GA18718@localhost>
References: <20121023124856.GA17692@localhost>
 <5086971A.1070009@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5086971A.1070009@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 03:09:46PM +0200, Daniel Lezcano wrote:
> On 10/23/2012 02:48 PM, Fengguang Wu wrote:
> 
> Hi Fengguang,
> 
> I believe this bug has been fixed by https://lkml.org/lkml/2012/10/8/87

Yeah, I just confirmed that linux-next works fine.

Thanks,
Fengguang
