Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760930Ab2EQMs1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 08:48:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61746 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757731Ab2EQMsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 08:48:25 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Subject: GFS2: Pre-pull patch posting (merge window)
Date: Thu, 17 May 2012 13:23:07 +0100
Message-Id: <1337257411-3173-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Since the merge window appears to be fast approaching, here are the
current GFS2 patches. This time there are two main themes, one is
updates to the log code, mostly on the writing side. The other is
preparation for some block reservation work which will probably
land in the subsequent merge window.

There is of course the usual collection of cleanup and bug fixes
as well. See the individual patches for the detailed descriptions,

Steve.


