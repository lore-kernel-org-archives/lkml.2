Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682Ab1BDNLm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 08:11:42 -0500
Received: from casper.infradead.org ([85.118.1.10]:47794 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135Ab1BDNLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 08:11:41 -0500
Subject: Re: [PATCH 0/2] perf_events: add support for Intel fixed counter 2
From: Peter Zijlstra <peterz@infradead.org>
To: eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
        davem@davemloft.net, fweisbec@gmail.com, perfmon2-devel@lists.sf.net,
        eranian@gmail.com, robert.richter@amd.com, acme@redhat.com,
        gorcunov@gmail.com, ming.m.lin@intel.com
In-Reply-To: <4d4bf9ac.cf03d90a.2908.2186@mx.google.com>
References: <4d4bf9ac.cf03d90a.2908.2186@mx.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Feb 2011 14:12:40 +0100
Message-ID: <1296825160.26581.652.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-04 at 14:00 +0200, Stephane Eranian wrote:

> This series of patches solves this problem by introducing a custom
> encoding for UNHALTED_REFERENCE_CYCLES (0xff3c) and improving
> the constraint infrastructure to handle events which can ONLY be
> measured on fixed counters.

Right, so the only problem I can see with this is that Intel will at
some point in the future put an actual event there.

