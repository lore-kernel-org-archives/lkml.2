Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805Ab2GBT0y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 15:26:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33781 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752Ab2GBT0x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 15:26:53 -0400
Message-ID: <1341257194.23484.16.camel@twins>
Subject: Re: [PATCH 1/5] perf, x86: Improve basic Ivy Bridge support v3
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Date: Mon, 02 Jul 2012 21:26:34 +0200
In-Reply-To: <1341254598-1379-2-git-send-email-andi@firstfloor.org>
References: <1341254598-1379-1-git-send-email-andi@firstfloor.org>
	 <1341254598-1379-2-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-02 at 11:43 -0700, Andi Kleen wrote:
> - As Stephane pointed out .code=0xb1, .umask=0x01 is gone from the
> event list,
> so don't do a generic backend stall event on IvyBridge. 

325462-043US, May 2012:

Page 3135, Table 19-2. Non-Architectural Performance Events In the
Processor Core of Third Generation Intel Core i7, i5, i3 Processors

(aka. IvyBridge)

B1H 01H UOPS_EXECUTED.THREAD Counts total number of uops to be
                             executed per-thread each cycle. Set
                             Cmask = 1, INV =1 to count stall
                             cycles.

