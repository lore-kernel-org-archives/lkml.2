Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757616Ab0KRNbS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 08:31:18 -0500
Received: from one.firstfloor.org ([213.235.205.2]:42010 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756583Ab0KRNbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 08:31:17 -0500
Date: Thu, 18 Nov 2010 14:31:12 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>, acme@redhat.com, mingo@elte.hu,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/2] perf: Fix compilation on gcc 4.0.2
Message-ID: <20101118133112.GC12667@basil.fritz.box>
References: <1290077461-12321-1-git-send-email-andi@firstfloor.org>
 <1290077461-12321-2-git-send-email-andi@firstfloor.org>
 <1290078937.2109.1345.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290078937.2109.1345.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Should we be using more of the kernel makefile magic to detect this?

In theory yes, but the two warnings didn't seem to be too useful
to me so it's probably not worth it just for those two.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
