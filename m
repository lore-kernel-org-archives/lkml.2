Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932474Ab2EYWyR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 18:54:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:48919 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756185Ab2EYWyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 18:54:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="148592441"
From: Andi Kleen <andi@firstfloor.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, tj@kernel.org,
        axboe@kernel.dk, agk@redhat.com, neilb@suse.de,
        drbd-dev@lists.linbit.com, bharrosh@panasas.com, vgoyal@redhat.com,
        mpatocka@redhat.com, sage@newdream.net, yehuda@hq.newdream.net
Subject: Re: [PATCH v2 12/14] Closures
References: <1337817771-25038-1-git-send-email-koverstreet@google.com>
	<1337817771-25038-13-git-send-email-koverstreet@google.com>
Date: Fri, 25 May 2012 15:54:14 -0700
In-Reply-To: <1337817771-25038-13-git-send-email-koverstreet@google.com> (Kent
	Overstreet's message of "Wed, 23 May 2012 17:02:49 -0700")
Message-ID: <m2k3zzlvmx.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kent Overstreet <koverstreet@google.com> writes:

> Asynchronous refcounty thingies; they embed a refcount and a work
> struct. Extensive documentation follows in include/linux/closure.h

Sounds like you reinvented WTDs? 

Anyways I don't think this is something that should be in a kernel.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
