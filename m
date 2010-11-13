Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661Ab0KMJPP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 04:15:15 -0500
Received: from one.firstfloor.org ([213.235.205.2]:46612 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637Ab0KMJPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 04:15:13 -0500
Date: Sat, 13 Nov 2010 11:17:53 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu, fweisbec@gmail.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/2] perf-events: Add support for supplementary event
 registers v2
Message-ID: <20101113101753.GE6418@gargoyle.fritz.box>
References: <1289580941-29744-1-git-send-email-andi@firstfloor.org>
 <AANLkTimJ3nLwmRfmf+uTuUvg6HVrHBzrjgQXuTi5dxyp@mail.gmail.com>
 <1289583192.2084.339.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289583192.2084.339.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That would assume a single event doesn't contain offcore and lbr, no?
> Currently the extra_reg thing assumes there's only one extra reg encoded
> in the config word.

It would not be too hard to make it an array if that's needed.

Before going fancy I would prefer to include the plain base patch
first though.

-Andi
