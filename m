Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932491Ab2K1P1v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 10:27:51 -0500
Received: from mga11.intel.com ([192.55.52.93]:17886 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932401Ab2K1P1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 10:27:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,179,1355126400"; 
   d="scan'208";a="255955710"
Date: Wed, 28 Nov 2012 07:27:47 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, mingo@elte.hu, acme@redhat.com,
        namhyung.kim@lge.com
Subject: Re: [PATCH v3 04/19] perf, core: Add a concept of a weightened sample
Message-ID: <20121128152747.GH2584@tassilo.jf.intel.com>
References: <1353502185-26521-1-git-send-email-eranian@google.com>
 <1353502185-26521-5-git-send-email-eranian@google.com>
 <20121128152327.GD1038@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121128152327.GD1038@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > @@ -198,8 +200,9 @@ enum perf_event_read_format {
> >  	PERF_FORMAT_TOTAL_TIME_RUNNING		= 1U << 1,
> >  	PERF_FORMAT_ID				= 1U << 2,
> >  	PERF_FORMAT_GROUP			= 1U << 3,
> > +	PERF_FORMAT_WEIGHT			= 1U << 4,
> 
> what's PERF_FORMAT_WEIGHT for?

It was used in a earlier iteration, but is now obsolete. I'll remove it.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
