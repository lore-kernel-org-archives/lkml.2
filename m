Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275Ab2AEMPx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 07:15:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4710 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754562Ab2AEMPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 07:15:52 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Subject: GFS2: Pre-pull patch posting (merge window)
Date: Thu,  5 Jan 2012 11:51:46 +0000
Message-Id: <1325764322-10807-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The main feature this time is clean up around the allocation and
resource group code. Otherwise the remainder is mostly small
bug fixes.

I've held back the glock stats patch and that will probably be
ready for the following merge window with a bit of luck,

Steve.

