Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375Ab2GWQgf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 12:36:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:37038 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644Ab2GWQge convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 12:36:34 -0400
Message-ID: <1343061382.26034.1.camel@twins>
Subject: Re: [PATCH 2/4] perf/x86: Fix format definition of SNB-EP uncore
 QPI box
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Stephane Eranian <eranian@google.com>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, mingo@elte.hu, andi@firstfloor.org,
        linux-kernel@vger.kernel.org
Date: Mon, 23 Jul 2012 18:36:22 +0200
In-Reply-To: <CABPqkBSLk_fCBEbVgNVc3iGsOFaSiKpPYF5krj_wymDP=SA6Cg@mail.gmail.com>
References: <1343024611-4692-1-git-send-email-zheng.z.yan@intel.com>
	 <1343024611-4692-2-git-send-email-zheng.z.yan@intel.com>
	 <CABPqkBSLk_fCBEbVgNVc3iGsOFaSiKpPYF5krj_wymDP=SA6Cg@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-23 at 18:33 +0200, Stephane Eranian wrote:
> 
> DEFINE_UNCORE_FORMAT_ATTR(event, event, "config:0-7,21");
> 
> Assuming the event parser supports disjoint bits. 

It does. Userspace should provide a 9bit value in this case and the 9th
bit will be stored in bit 21.
