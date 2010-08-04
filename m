Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933007Ab0HDPFS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 11:05:18 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51696 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932843Ab0HDPFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 11:05:17 -0400
From: Andi Kleen <andi@firstfloor.org>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Simon Horman <horms@verge.net.au>, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michael Neuling <mikey@neuling.org>
Subject: Re: [rfc] Merge kexec-tools into the kernel tree
References: <20100804070647.GB24064@verge.net.au>
	<m17hk6de62.fsf@fess.ebiederm.org>
Date: Wed, 04 Aug 2010 17:05:08 +0200
In-Reply-To: <m17hk6de62.fsf@fess.ebiederm.org> (Eric W. Biederman's message
	of "Wed, 04 Aug 2010 00:34:29 -0700")
Message-ID: <87bp9ie7vf.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ebiederm@xmission.com (Eric W. Biederman) writes:
>
> I'm afraid that someone has a good answer for why their lives would be
> simpler if /sbin/kexec was in the kernel tree and I will be absolutely
> horrified and about someones stupidity when I hear that answer.

Same here. In fact I guess it would be counter productive: it would
discourage a stable API between the kernel and the user tool.
We're seeing this problem with other user tools which are in 
the kernel tree.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
