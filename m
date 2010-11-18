Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635Ab0KRKru (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 05:47:50 -0500
Received: from one.firstfloor.org ([213.235.205.2]:42114 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224Ab0KRKrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 05:47:47 -0500
From: Andi Kleen <andi@firstfloor.org>
To: a.p.zijlstra@chello.nl
Cc: eranian@google.com, linux-kernel@vger.kernel.org, x86@kernel.org
Subject: perf offcore patchkit for merge
Date: Thu, 18 Nov 2010 11:47:30 +0100
Message-Id: <1290077254-12165-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the latest version of the perf offcore / extra regs
patchkit. I addressed all earlier comments I believe and
this should be ready for merge now.

- Allocating multiple registers is supported now
- I kept the percore allocation because the manual
kmalloc method turned out to be more complicated and 
alloc_percpu() really already did what I wanted.
However I switched to using the CPU notifier to set up the 
topology for hotplug, together with a bugfix to make sure 
x86 sets up the topology before calling it.
- A few other improvements.

-Andi
