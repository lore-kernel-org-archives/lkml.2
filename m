Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538Ab1ADUn4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 15:43:56 -0500
Received: from mga02.intel.com ([134.134.136.20]:3630 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426Ab1ADUnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 15:43:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,274,1291622400"; 
   d="scan'208";a="589853588"
From: Darren Hart <dvhart@linux.intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tom Zanussi <tom.zanussi@intel.com>
Subject: trace-cmd: fix python bindings
Date: Tue,  4 Jan 2011 12:43:37 -0800
Message-Id: <1294173820-7043-1-git-send-email-dvhart@linux.intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The python bindings stopped working after some changes to trace-cmd. This 
series addresses the bindings and python object member naming issues. With
these changes, event-viewer.py and the tracecmd.py self-tests work again.

--
Darren

