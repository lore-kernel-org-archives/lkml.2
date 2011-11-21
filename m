Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623Ab1KUO4D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 09:56:03 -0500
Received: from casper.infradead.org ([85.118.1.10]:45506 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab1KUO4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 09:56:02 -0500
Message-Id: <20111121145114.049265181@chello.nl>
User-Agent: quilt/0.48-1
Date: Mon, 21 Nov 2011 15:51:14 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu
Cc: William Cohen <wcohen@redhat.com>, Stephane Eranian <eranian@google.com>,
        Arun Sharma <asharma@fb.com>, Vince Weaver <vince@deater.net>,
        linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 0/6] perf: x86 RDPMC and RDTSC support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These few patches implement x86 RDPMC support and add an extention to the self
monitoring data to also allow additional time updates using userspace TSC reads.

There's a few loose ends, but it mostly seems to work.

