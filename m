Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161598Ab2CSRVh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 13:21:37 -0400
Received: from home.keithp.com ([63.227.221.253]:59673 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932291Ab2CSRVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 13:21:35 -0400
From: Keith Packard <keithp@keithp.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>, dri-devel@lists.freedesktop.org
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Airlie <airlied@linux.ie>, rjw@sisk.pl, davej@redhat.com
Subject: Re: hibernate random memory corruption, workaround i915.modeset=0
In-Reply-To: <20120319145349.GG6169@redhat.com>
References: <20120227124243.GG4104@redhat.com> <20120319145349.GG6169@redhat.com>
User-Agent: Notmuch/0.11.1 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Mon, 19 Mar 2012 10:21:28 -0700
Message-ID: <86r4wobj6v.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<#part sign=pgpmime>
On Mon, 19 Mar 2012 15:53:54 +0100, Stanislaw Gruszka <sgruszka@redhat.com> wrote:

> Keith, is there a chance that this bug can be fixed by i915 team?

Yes, I'm working on figuring out how to actually reproduce this and then
work on a few work-arounds.

> If not, can we disable hibernate on i915 with modeset=1 and add
> module option, which enable it for those who want to risk?

I'd love to know if disabling modeset on just the booting kernel helps;
leaving the resuming kernel with modeset=1. I haven't been able to
reproduce this locally yet to test this theory though.

-- 
keith.packard@intel.com
