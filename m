Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524Ab2EGROQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 13:14:16 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58017 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757293Ab2EGROP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 13:14:15 -0400
Subject: Re: [PATCH 9/9] perf tool: Add pmu event alias support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jiri Olsa <jolsa@redhat.com>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, mingo@elte.hu, andi@firstfloor.org,
        eranian@google.com, ming.m.lin@intel.com, linux-kernel@vger.kernel.org
In-Reply-To: <20120503200518.GC1671@m.brq.redhat.com>
References: <1335924440-11242-1-git-send-email-zheng.z.yan@intel.com>
	 <1335924440-11242-10-git-send-email-zheng.z.yan@intel.com>
	 <20120503105655.GB1671@m.brq.redhat.com> <1336044261.22523.11.camel@twins>
	 <20120503200518.GC1671@m.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 May 2012 19:14:03 +0200
Message-ID: <1336410843.27020.77.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-03 at 22:05 +0200, Jiri Olsa wrote:
> thoughts?

The currently proposed syntax for aliases is 'pmu/alias,more-terms/'
right?

Should we also allow something like 'pmu/event=alias,more-terms/' ? Or
possibly even do only that?

The reason is that that would be much easier for the external events
Stephane wants with that JSON file. I think the sysfs alias and external
JSON alias should be the same mechanism and syntax.



