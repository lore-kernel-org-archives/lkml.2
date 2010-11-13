Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019Ab0KMKep (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 05:34:45 -0500
Received: from casper.infradead.org ([85.118.1.10]:49191 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755538Ab0KMKel convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 05:34:41 -0500
Subject: Re: [PATCH 1/2] perf-events: Add support for supplementary event
 registers v2
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu, fweisbec@gmail.com,
        Andi Kleen <ak@linux.intel.com>
In-Reply-To: <20101113101753.GE6418@gargoyle.fritz.box>
References: <1289580941-29744-1-git-send-email-andi@firstfloor.org>
	 <AANLkTimJ3nLwmRfmf+uTuUvg6HVrHBzrjgQXuTi5dxyp@mail.gmail.com>
	 <1289583192.2084.339.camel@laptop>
	 <20101113101753.GE6418@gargoyle.fritz.box>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 13 Nov 2010 11:34:22 +0100
Message-ID: <1289644462.2084.528.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-11-13 at 11:17 +0100, Andi Kleen wrote:
> > That would assume a single event doesn't contain offcore and lbr, no?
> > Currently the extra_reg thing assumes there's only one extra reg encoded
> > in the config word.
> 
> It would not be too hard to make it an array if that's needed.

I don't think we want to go there anyway, one extra_reg per config value
is fine.

