Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585Ab2IZIv3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 04:51:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7806 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753325Ab2IZIv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 04:51:27 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Subject: GFS2: Pre-pull patch posting (merge window)
Date: Wed, 26 Sep 2012 09:25:21 +0100
Message-Id: <1348647948-3219-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We've collected up a goodly number of patches in the -nmw tree now
and we can hold off any further changes until the following merge
window, so here is the current tree content.

The major feature this time is the "rbm" conversion in the resource
group code. The new struct gfs2_rbm specifies the location of an
allocatable block in (resource group, bitmap, offset) form. There
are a number of added helper functions, and later patches then
rewrite some of the resource group code in terms of this new
structure. Not only does this give us a nice code clean up, but
it also removes some of the previous restructions where extents
could not cross bitmap boundaries, for example.

In addition to that, there are a few bug fixes and clean ups, but
the rbm work is by far the majority of this patch set in terms of
number of changed lines.

Steve.


