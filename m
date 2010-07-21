Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758935Ab0GUWdJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 18:33:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:39730 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758903Ab0GUWdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 18:33:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,240,1278313200"; 
   d="scan'208";a="537637678"
Subject: Re: [PATCH 2/7] x86, xsave: introduce xstate enable functions
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4C476C5B.8020604@zytor.com>
References: <1279731838-1522-1-git-send-email-robert.richter@amd.com>
	 <1279731838-1522-3-git-send-email-robert.richter@amd.com>
	 <4C476236.1020302@zytor.com>
	 <1279747225.2812.37.camel@sbs-t61.sc.intel.com>
	 <4C476C5B.8020604@zytor.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Wed, 21 Jul 2010 15:32:28 -0700
Message-Id: <1279751548.2812.77.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-07-21 at 14:53 -0700, H. Peter Anvin wrote:
> On 07/21/2010 02:20 PM, Suresh Siddha wrote:
> > 
> > Yes, it should be __init.
> > 
> 
> OK, here is the proposed fix for that.  It's a bit uglier than I would
> have liked.
> 
> It also fixes the assumption that "we are on the boot CPU so we are
> early in the boot", which is true now but will not be true in the future
> when we can offline (and later re-online) the boot CPU.
> 
> Comments appreciated...

I am ok with this fix. Thanks for taking a stab at this.

suresh

