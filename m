Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029Ab1AEK6b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 05:58:31 -0500
Received: from casper.infradead.org ([85.118.1.10]:46464 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948Ab1AEK6a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 05:58:30 -0500
Subject: Re: [PATCH 0/5] perf_events: add support for per-cpu per-cgroup
 monitoring (v7)
From: Peter Zijlstra <peterz@infradead.org>
To: eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
        davem@davemloft.net, fweisbec@gmail.com, perfmon2-devel@lists.sf.net,
        eranian@gmail.com, robert.richter@amd.com, acme@redhat.com,
        lizf@cn.fujitsu.com
In-Reply-To: <4d220584.4902d90a.23e4.0c78@mx.google.com>
References: <4d220584.4902d90a.23e4.0c78@mx.google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 05 Jan 2011 11:58:33 +0100
Message-ID: <1294225113.2016.237.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've applied 1,2 and 3. I'll wait for a fixed 4 and a rebased 5 (won't
apply to current -tip).
