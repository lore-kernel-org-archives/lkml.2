Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934Ab2GWI0I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 04:26:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38393 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751063Ab2GWI0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 04:26:05 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Subject: GFS2: Pre-pull patch posting (merge window)
Date: Mon, 23 Jul 2012 09:00:50 +0100
Message-Id: <1343030466-3053-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

As usual, here is the content of the GFS2 tree prior to sending
a merge request. Not a huge number of patches this time, but some
interesting features nonetheless.

A number of the earlier patches are aimed at cleaning up the resource
group code for the later patch which implements block reservations.
In addition to that, there are a few patches aimed at improving
the time taken to dump (the potentially rather large) glock debugfs
file. Beyond that there are a couple of bug fixes and thats about it
this time,

Steve.

