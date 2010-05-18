Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612Ab0ERVYu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 17:24:50 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52924 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225Ab0ERVYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 17:24:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:user-agent:date:from:to:cc:subject;
        b=EUuSsT4eN3Bx/e8EWNZK2QBeE/i2829w4zG8ZapxhRYOd3+xZbn9OdGpy7fRykvKvN
         LUyCzjRdzcXiIdS1KEzCPXBNi0fdIBY42M4BrPjVsUDbFzv2Bj8YzxsGKAMijaGRjD01
         I3ZXiFqPZaRVeeYgSSQO9vVS9WvZWNr8upUJo=
Message-Id: <20100518211916.407689068@openvz.org>
User-Agent: quilt/0.47-1
Date: Wed, 19 May 2010 01:19:16 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Lin Ming <ming.m.lin@intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       =?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>
Subject: [patch 0/4] [perf -tip/master] p4 pmu updates
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, please pick up the following patches. Nothing serious --
a few nitfix and preparation the header for future export into
user space (in a sake of RAW events), though not exported in
real yet. Need to estimate the convenience of its usage.

Comments and complains and etc are highly appreciated!

	-- Cyrill
