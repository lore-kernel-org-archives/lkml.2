Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085Ab0LQMqE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 07:46:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10054 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752553Ab0LQMqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 07:46:01 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Subject: GFS2: Pre-pull patch posting (-nmw)
Date: Fri, 17 Dec 2010 12:24:06 +0000
Message-Id: <1292588661-14350-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a bit early this time, but I'm not expecting to add any more
features to this patch set before the merge window. In fact it is
mostly clean up and fixes anyway. So I'm pushing it out now to let
everybody see it ahead of time.

The only user visible new feature this time is the addition of
support for updating quota usage values through the quotactl
interface. This addition means that all of GFS2's quota operations
will be accessible via the generic quota-tools userland package
very shortly. This is a precursor to being able to drop the userland
gfs2_quota tool and use the generic quota tools for all GFS2 quota
operations at some future date.

I'm planning to keep the glock scalability patch (previously posted
on cluster-devel) until the following merge window, since that is
a fairly large patch, and it should be ready to go into my -nmw tree
as the first patch of the new -nmw tree with a bit of luck.

Other than that I don't think there is much else noteworthy this
time,

Steve.


