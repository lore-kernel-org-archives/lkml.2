Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757841Ab2C2IUL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 04:20:11 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43366 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637Ab2C2IUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 04:20:06 -0400
Message-ID: <4F741AED.6090901@kernel.dk>
Date: Thu, 29 Mar 2012 10:18:53 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: vgoyal@redhat.com, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org
Subject: Re: [PATCHSET] block: modularize blkcg config and stat file handling
References: <1332975091-10950-1-git-send-email-tj@kernel.org>
In-Reply-To: <1332975091-10950-1-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2012 12:51 AM, Tejun Heo wrote:
> and is on top of
> 
>   block/for-3.5/core eb7d8c07f9 "cfq: fix cfqg ref handling..."
> + [1] cgroup-cftypes d954ca6469 "cgroup: implement cgroup_rm_cftypes()"
> 
> Note that the cgroup branch is temporary and the merge between the two
> branches aren't trivial.  I'll prepare a proper merged branch once the
> cgroup/for-3.5 branch is settled.

The diffstat is very tasty... I'll leave this on out until the cgroup
merge mess is settled, though.

-- 
Jens Axboe

