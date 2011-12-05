Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932721Ab1LEWkM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 17:40:12 -0500
Received: from casper.infradead.org ([85.118.1.10]:40066 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932486Ab1LEWkK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 17:40:10 -0500
Message-ID: <1323124766.32012.49.camel@twins>
Subject: Re: [PATCH 00/12] perf_events: add support for sampling taken
 branches (v2)
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, acme@redhat.com,
        ming.m.lin@intel.com, andi@firstfloor.org, robert.richter@amd.com,
        ravitillo@lbl.gov, will.deacon@arm.com, paulus@samba.org,
        benh@kernel.crashing.org, rth@twiddle.net, ralf@linux-mips.org,
        davem@davemloft.net, lethal@linux-sh.org
Date: Mon, 05 Dec 2011 23:39:26 +0100
In-Reply-To: <1318595833-29984-1-git-send-email-eranian@google.com>
References: <1318595833-29984-1-git-send-email-eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-14 at 14:37 +0200, Stephane Eranian wrote:
> This patchset adds an important and useful new feature to
> perf_events: branch stack sampling. In other words, the
> ability to capture taken branches into each sample.
> 
Other than the few comments given it all looks good. My main worry is
the Intel only aspect, I'd really love for there to be another platform
that could implement at least part of this.


