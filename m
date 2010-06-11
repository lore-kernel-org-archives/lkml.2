Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760026Ab0FKBSU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 21:18:20 -0400
Received: from mga11.intel.com ([192.55.52.93]:21536 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754520Ab0FKBST (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 21:18:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,400,1272870000"; 
   d="scan'208";a="575325360"
Subject: Re: [PATCH 1/2] Add HW_ERR printk prefix for hardware error logging
From: Huang Ying <ying.huang@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20100610164607.b2908334.akpm@linux-foundation.org>
References: <1275978938.3444.667.camel@yhuang-dev.sh.intel.com>
	 <20100610164607.b2908334.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Jun 2010 09:18:15 +0800
Message-ID: <1276219095.3004.36.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-11 at 07:46 +0800, Andrew Morton wrote:
> On Tue, 08 Jun 2010 14:35:38 +0800
> Huang Ying <ying.huang@intel.com> wrote:
> 
> > This makes hardware error related log in printk log more explicit. So
> > that the users can report it to hardware vendor instead of LKML or
> > software vendor.
> > 
> 
> Spose so.  Some additional words explaining why you think this would
> result in an improved kernel would help here.  Are you seeing
> misdirected problem reports?  Are we missing out on opportunities to
> fix hardware?  What is driving for this change?  Will it bring out some
> improvement in something which you're seeing within Intel or was it
> just a random hey-lets-try-this thing?

It is said by Andi Kleen that many users report Machine Check hardware
error message as software error to him or software vendor instead of as
hardware error to hardware vendor. This does not help much for the users
to resolve their problem. So I think it is better to make the kernel
hardware error log more explicit for these users.

Best Regards,
Huang Ying


