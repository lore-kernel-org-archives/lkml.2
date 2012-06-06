Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551Ab2FFRZ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 13:25:29 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40736 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757422Ab2FFRZ2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 13:25:28 -0400
Message-ID: <1339003517.23343.7.camel@twins>
Subject: Re: [PATCH 2/5] perf, x86: Don't assume there can be only 4 PEBS
 events
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com,
        Andi Kleen <ak@linux.intel.com>
Date: Wed, 06 Jun 2012 19:25:17 +0200
In-Reply-To: <20120606161044.GH27374@one.firstfloor.org>
References: <1338944211-28275-1-git-send-email-andi@firstfloor.org>
	 <1338944211-28275-2-git-send-email-andi@firstfloor.org>
	 <1338994803.2749.132.camel@twins>
	 <20120606161044.GH27374@one.firstfloor.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-06 at 18:10 +0200, Andi Kleen wrote:
> FWIW I saw the warn on triggering.

What hardware and what workload?
