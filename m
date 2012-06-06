Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431Ab2FFRLA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 13:11:00 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40717 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754187Ab2FFRK7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 13:10:59 -0400
Message-ID: <1339002645.2749.151.camel@twins>
Subject: Re: [PATCH 1/5] perf, x86: Don't assume the alternative cycles
 encoding is architectural
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        eranian@google.com
Date: Wed, 06 Jun 2012 19:10:45 +0200
In-Reply-To: <20120606160848.GG27374@one.firstfloor.org>
References: <1338944211-28275-1-git-send-email-andi@firstfloor.org>
	 <1338979188.2749.92.camel@twins>
	 <20120606141247.GD28225@tassilo.jf.intel.com>
	 <1338992061.2749.111.camel@twins>
	 <20120606142323.GG28225@tassilo.jf.intel.com>
	 <1338992910.2749.121.camel@twins>
	 <20120606143536.GH28225@tassilo.jf.intel.com>
	 <1338993726.2749.125.camel@twins>
	 <20120606144952.GK28225@tassilo.jf.intel.com>
	 <1338994385.2749.130.camel@twins>
	 <20120606160848.GG27374@one.firstfloor.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-06 at 18:08 +0200, Andi Kleen wrote:
> How about newer unknown Intel CPUs with arch_perfmon >= 3? Those would get 
> intel_pmu, correct?  There's no guarantee that they support the trick.

But they will have no PEBS constraints set, so effectively don't have
PEBS.
