Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab0CWImm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 04:42:42 -0400
Received: from mga05.intel.com ([192.55.52.89]:32843 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752284Ab0CWImk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 04:42:40 -0400
Message-Id: <89kc63$gdp6nr@fmsmga002.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,293,1267430400"; 
   d="scan'208";a="551328507"
Date: Tue, 23 Mar 2010 08:42:34 +0000
To: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 11/18] i915: Provide config option for enabling tracepoints
Cc: dri-devel@lists.sourceforge.net, Jan Kara <jack@suse.cz>
References: <1269304340-25372-1-git-send-email-jack@suse.cz> <1269304340-25372-12-git-send-email-jack@suse.cz>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <1269304340-25372-12-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Out of curiosity what motivated this patch? When adding the tracepoints,
I found the overhead of compiling in but not enabling them to be
insignificant, i.e. nearly unmeasurable in throughput benchmarks, so
didn't believe it warranted a config option. Especially one that advises
people to turn off what may be a useful aid in desktop systems.

Also is TRACER the right name, that would seem to confuse the option with
a standalone tracer as opposed to simply enabling tracepoints.
-ickle

-- 
Chris Wilson, Intel Open Source Technology Centre
