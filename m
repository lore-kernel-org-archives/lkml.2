Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756382Ab0EYIky (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 04:40:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26991 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756333Ab0EYIkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 04:40:47 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: GFS2: Pre-pull patch posting (fixes)
Date: Tue, 25 May 2010 09:21:26 +0100
Message-Id: <1274775689-4689-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These are three important, but relatively small, bug fixes for GFS2.
The first prevents a kernel BUG triggering in a relatively unlikely
(but possible) scenario when a log flush caused by glock demotion
races with a log flush from some other initiator (e.g. fsync).

The second and third patches add extra conditions to two areas
of code. This makes their behaviour match ext3 in those cases,

Steve.


