Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144Ab2FNNlp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 09:41:45 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55704 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028Ab2FNNln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 09:41:43 -0400
Date: Thu, 14 Jun 2012 15:41:42 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/2] perf, x86: Add basic Ivy Bridge support v3
Message-ID: <20120614134142.GI11413@one.firstfloor.org>
References: <1339615201-7456-1-git-send-email-andi@firstfloor.org> <1339622672.8980.61.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339622672.8980.61.camel@twins>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I really don't see the point of this patch,.. it is in fact using the
> SandyBridge events.. 

It needs a separate path for the PDIR change and for not doing the PEBS
workaround and for printing Ivy instead of Sandy. I had it originally merged in v1 with a 
goto, but Ingo thought it was obfuscated, so it became a separate block.
If you disagree with Ingo please take it up with him.

> also you appear to have removed the backend stalls
> which per SDM (may 2012) table 19-2 would be the very same.

Stephane said that event doesn't exist anymore and I agree with him.
You cannot just base it on the SDM, it's SDM plus whatever is currently
known.

Besides they are misleading and wrong in any case.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
