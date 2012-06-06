Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816Ab2FFKkB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 06:40:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:33202 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798Ab2FFKkA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 06:40:00 -0400
Message-ID: <1338979188.2749.92.camel@twins>
Subject: Re: [PATCH 1/5] perf, x86: Don't assume the alternative cycles
 encoding is architectural
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com,
        Andi Kleen <ak@linux.intel.com>
Date: Wed, 06 Jun 2012 12:39:48 +0200
In-Reply-To: <1338944211-28275-1-git-send-email-andi@firstfloor.org>
References: <1338944211-28275-1-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-05 at 17:56 -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> cycles:p uses an special cycles encoding by default. However that is not
> architectural, so it can only be used when the CPU is known
> (it already caused problems on Sandy Bridge). It may or may not work
> on future CPUs.
> 
> So make it opt-in only. Right now I enabled it on Core2, Nehalem, Westmere
> and not on Sandy-Bridge or Atom.

No. Also, c0 is a PEBS capable event on Atom just fine.
