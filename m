Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309Ab2DBUCk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 16:02:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63508 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880Ab2DBUCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 16:02:39 -0400
Date: Mon, 2 Apr 2012 13:02:33 -0700
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: vgoyal@redhat.com, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org
Subject: Re: [PATCHSET] block: modularize blkcg config and stat file
 handling
Message-ID: <20120402200233.GB17175@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1332975091-10950-1-git-send-email-tj@kernel.org>
 <4F741AED.6090901@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F741AED.6090901@kernel.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Jens.

On Thu, Mar 29, 2012 at 10:18:53AM +0200, Jens Axboe wrote:
> The diffstat is very tasty... I'll leave this on out until the cgroup
> merge mess is settled, though.

The following branch contains this patchset on top of the current
block/for-3.5/core 959d851caa "Merge branch 'for-3.5' of ../cgroup
into block/for-3.5/core-merged".

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git blkcg-files

Other than $SUBJ update on the eigth patch from "blkcg:
blkg_conf_prep()" to "blkcg: simplify blkg_conf_prep()", the patchset
can be applied as-is on top of the current block/for-3.5/core.

Thanks.

-- 
tejun
