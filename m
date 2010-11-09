Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473Ab0KIL1Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 06:27:25 -0500
Received: from mga02.intel.com ([134.134.136.20]:56652 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755203Ab0KIL1Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 06:27:24 -0500
Message-Id: <b9dded$h15mrt@orsmga002.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,174,1288594800"; 
   d="scan'208";a="571661181"
Date: Tue, 09 Nov 2010 11:27:18 +0000
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] tracing: introduce trace_set_clr_module_event
Cc: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com
In-Reply-To: <20101109112320.GA21828@localhost.localdomain>
References: <1289293967-31761-1-git-send-email-yuanhan.liu@linux.intel.com> <1289293967-31761-2-git-send-email-yuanhan.liu@linux.intel.com> <20101109112320.GA21828@localhost.localdomain>
From: Chris Wilson <chris@chris-wilson.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Nov 2010 19:23:20 +0800, Yuanhan Liu <yuanhan.liu@linux.intel.com> wrote:
> Besides that, any comments? 

I've not looked closely at this yet, but it seems like we should be able
to hook into a trace_module_notify and implement a generic option parser
from within trace/ as opposed to each individual module.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
