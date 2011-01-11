Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548Ab1AKKKx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 05:10:53 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:47712 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015Ab1AKKKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 05:10:48 -0500
Date: Tue, 11 Jan 2011 15:40:40 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>
Subject: [PATCH -tip 0/2] sched: Get group names back in /proc/sched_debug -
 v1
Message-ID: <20110111101040.GD4772@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset adds group names back to /proc/sched_debug. This v1 post
addresses the comments received during initial post (https://lkml.org/lkml/2011/1/10/2)

Mike, you may want to add your sign off since I took pieces of your code
from your review comments.

Regards,
Bharata.
