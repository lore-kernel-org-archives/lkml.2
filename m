Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616Ab0DWFVU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 01:21:20 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:51049 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267Ab0DWFVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 01:21:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IOgcj0Q4Duyqnyuoya8n23MiXZTBILuK5xxcToAKV20BJDlwJg5sVZMfq/Dc+nBpsf
         9cBwqjD8dSmANE3qp+mHppfsMU53o/X0/pC2oAiya2HXm4XCuKjWtQws7RoyRK+rgic1
         1MiLEcZiKc5doVrEL1ugnrrhq0KziQ0csLKQ8=
Date: Fri, 23 Apr 2010 07:21:25 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Will Deacon <will.deacon@arm.com>,
       Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>,
       "K . Prasad" <prasad@linux.vnet.ibm.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Jason Wessel <jason.wessel@windriver.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 3/6] hw-breakpoints: Change/Enforce some breakpoints
	policies
Message-ID: <20100423052124.GG5600@nowhere>
References: <1271999639-23605-1-git-send-regression-fweisbec@gmail.com> <1271999639-23605-4-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271999639-23605-4-git-send-regression-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 23, 2010 at 07:13:56AM +0200, Frederic Weisbecker wrote:
>  kernel/trace/trace_functions_graph.c |    2 +


Sorry for the part on this file, it's an unrelated leftover, I'll
drop it from the final set.

