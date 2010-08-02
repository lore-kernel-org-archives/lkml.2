Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab0HBJs7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 05:48:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50065 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750787Ab0HBJs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 05:48:58 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Subject: GFS2: Pre-pull patch posting
Date: Mon,  2 Aug 2010 10:27:51 +0100
Message-Id: <1280741279-6782-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is the current content of the GFS2 -nmw git tree. Mostly its
just clean up and bug fixes this time. There is one exception which
is the "wait for journal id" patch which is a new feature aimed
at (eventually) allowing us to simplify the userland support which
GFS2 requires,

Steve.

