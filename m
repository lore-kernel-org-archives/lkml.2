Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681Ab0KRKvK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 05:51:10 -0500
Received: from one.firstfloor.org ([213.235.205.2]:42148 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755758Ab0KRKvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 05:51:08 -0500
From: Andi Kleen <andi@firstfloor.org>
To: acme@redhat.com
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org
Subject: Some perf user space improvements
Date: Thu, 18 Nov 2010 11:50:59 +0100
Message-Id: <1290077461-12321-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two patches fix two problems in the "perf" tool I ran  
into recently. The main one is fixing the compilation on gcc 4.0,
which one of my test boxes still uses (that's actually
an old patch submitted some time ago, but never got applied)

-Andi

