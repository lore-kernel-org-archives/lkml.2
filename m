Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab1GHA2e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 20:28:34 -0400
Received: from smtp-out.google.com ([74.125.121.67]:40109 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab1GHA2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 20:28:33 -0400
From: Dima Zavin <dima@android.com>
To: linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 0/1] plist: remove the need to supply locks to plist heads
Date: Thu,  7 Jul 2011 17:27:58 -0700
Message-Id: <1310084879-10351-1-git-send-email-dima@android.com>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As discussed in the thread for the patch
   
   plist: add mutex to the blessed lock type for plists

I have removed the need to supply a lock to a plist head altogether
and updated all the users.

--Dima

