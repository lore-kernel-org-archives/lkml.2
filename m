Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128Ab2KGKl5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 05:41:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44243 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300Ab2KGKl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 05:41:56 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Subject: GFS2: Pre-pull patch posting (fixes)
Date: Wed,  7 Nov 2012 10:15:52 +0000
Message-Id: <1352283359-3314-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here are a number of GFS2 bug fixes. There are three from Andy Price
which fix various issues spotted by automated code analysis. There are two
from Lukas Czerner fixing my mistaken assumptions as to how FITRIM
should work. Finally Ben Marzinski has fixed a bug relating to mmap and
atime and also a bug relating to a locking issue in the transaction code.

Steve.

