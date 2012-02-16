Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468Ab2BPSRy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 13:17:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26609 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754324Ab2BPSRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 13:17:48 -0500
Date: Thu, 16 Feb 2012 18:26:26 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: apw@canonical.com, arjan@linux.intel.com, fhrbata@redhat.com,
        john.johansen@canonical.com, penguin-kernel@I-love.SAKURA.ne.jp,
        rientjes@google.com, rusty@rustcorp.com.au, tj@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] make vfork() killable
Message-ID: <20120216172626.GA30393@redhat.com>
References: <20120214164709.GA21178@redhat.com> <20120214164914.GF21185@redhat.com> <20120215123049.6e938eed.akpm@linux-foundation.org> <20120216150429.GB11953@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120216150429.GB11953@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16, Oleg Nesterov wrote:
>
> Btw, there is another example of "unbounded" sleep in UNINTERRUPTIBLE,
> vfork. I already have the patches, will send today.

Make vfork() killable, please apply.

These patches are old (Aug 2011), they spent a lot of time in linux-next
without any problem. Linus participated in the discussion, iiuc he has
no objections.

The next step is make vfork() stoppable/traceable.

Oleg.

