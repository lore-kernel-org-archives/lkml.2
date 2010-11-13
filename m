Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944Ab0KMKax (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 05:30:53 -0500
Received: from canuck.infradead.org ([134.117.69.58]:40967 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298Ab0KMKat convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 05:30:49 -0500
Subject: Re: [BUG 2.6.27-rc1] find_busiest_group() LOCKUP
From: Peter Zijlstra <peterz@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Nikanth Karthikesan <knikanth@suse.de>,
        Yinghai Lu <yinghai@kernel.org>, David Rientjes <rientjes@google.com>,
        "Zheng, Shaohui" <shaohui.zheng@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-hotplug@vger.kernel.org
In-Reply-To: <20101113084018.GA23098@localhost>
References: <20101111100628.GA24728@localhost>
	 <1289478978.2084.74.camel@laptop> <20101111124015.GA9706@localhost>
	 <1289480656.2084.80.camel@laptop>  <20101113084018.GA23098@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 13 Nov 2010 11:30:24 +0100
Message-ID: <1289644224.2084.521.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-11-13 at 16:40 +0800, Wu Fengguang wrote:
> > Will try and figure out how the heck that's happening, Ingo any clue?
> 
> It's back to normal on 2.6.37-rc1 when reverting commit 50f2d7f682f9
> ("x86, numa: Assign CPUs to nodes in round-robin manner on fake NUMA").
> 
> The interesting part is, the commit was introduced in 
> 2.6.36-rc7..2.6.36, however 2.6.36 boots OK, while 2.6.37-rc1 panics.

Argh, that commit again..

Does this fix it: http://lkml.org/lkml/2010/11/12/8


