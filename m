Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756367Ab2FFPAM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 11:00:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:38397 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789Ab2FFPAL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 11:00:11 -0400
Message-ID: <1338994803.2749.132.camel@twins>
Subject: Re: [PATCH 2/5] perf, x86: Don't assume there can be only 4 PEBS
 events
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com,
        Andi Kleen <ak@linux.intel.com>
Date: Wed, 06 Jun 2012 17:00:03 +0200
In-Reply-To: <1338944211-28275-2-git-send-email-andi@firstfloor.org>
References: <1338944211-28275-1-git-send-email-andi@firstfloor.org>
	 <1338944211-28275-2-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-05 at 17:56 -0700, Andi Kleen wrote:
> On Sandy Bridge in non HT mode there are 8 counters available. Since every
> counter can write a PEBS record assuming there are 4 max is incorrect. Use
> the reported counter number -- with an upper limit for a static array -- instead.


While I queued this patch, its effectively a NOP since all SNB PEBS
constraints are still on 4 counters.
