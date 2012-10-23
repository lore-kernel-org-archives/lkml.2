Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248Ab2JWMou (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 08:44:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:41690 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524Ab2JWMot convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 08:44:49 -0400
Message-ID: <1350996273.13456.19.camel@twins>
Subject: Re: [PATCH 11/34] perf, tools: Add abort,notx,intx branch filter
 options to perf report -j
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, acme@redhat.com,
        eranian@google.com, Andi Kleen <ak@linux.intel.com>
Date: Tue, 23 Oct 2012 14:44:33 +0200
In-Reply-To: <1350602382-12771-12-git-send-email-andi@firstfloor.org>
References: <1350602382-12771-1-git-send-email-andi@firstfloor.org>
	 <1350602382-12771-12-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-18 at 16:19 -0700, Andi Kleen wrote:
> +       BRANCH_OPT("abort", PERF_SAMPLE_BRANCH_ABORT),
> +       BRANCH_OPT("intx", PERF_SAMPLE_BRANCH_INTX),
> +       BRANCH_OPT("notx", PERF_SAMPLE_BRANCH_NOTX), 

I think we want tx in the abort name, its very much a transaction abort,
not any other kind of abort.


