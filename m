Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932520Ab1JRPNV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 11:13:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:8166 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932066Ab1JRPNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 11:13:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="64139522"
Date: Tue, 18 Oct 2011 08:13:16 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Borislav Petkov <bp@amd64.org>
Cc: Ingo Molnar <mingo@elte.hu>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 1/2] x86, microcode: Correct microcode revision format
Message-ID: <20111018151316.GA1345@alboin.amr.corp.intel.com>
References: <1318865115-9904-1-git-send-email-bp@amd64.org>
 <1318865115-9904-2-git-send-email-bp@amd64.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318865115-9904-2-git-send-email-bp@amd64.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 17, 2011 at 05:25:14PM +0200, Borislav Petkov wrote:
> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> 506ed6b53e00ba303ad778122f08e1fca7cf5efb added microcode revision format
> to /proc/cpuinfo and the MCE handler in decimal format but both AMD and
> Intel patch levels are handled as hex numbers. Fix it.

Acked-by: Andi Kleen <ak@linux.intel.com>

BTW if you want microcode output on AMD you'll need to implement
code to fill the field in on those CPUs.

-Andi
