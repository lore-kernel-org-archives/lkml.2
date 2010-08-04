Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759560Ab0HEAAM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 20:00:12 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:54119 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752620Ab0HEAAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 20:00:08 -0400
Date: Thu, 5 Aug 2010 00:59:49 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: David Daney <ddaney@caviumnetworks.com>
Cc: linux-mips@linux-mips.org, ananth@in.ibm.com,
        anil.s.keshavamurthy@intel.com, davem@davemloft.net,
        masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org,
        hschauhan@nulltrace.org
Subject: Re: [PATCH] MIPS: KProbes: Use flush_insn_slot() where possible.
Message-ID: <20100804235949.GE28115@linux-mips.org>
References: <1280859742-26364-4-git-send-email-ddaney@caviumnetworks.com>
 <1280869245-2786-1-git-send-email-ddaney@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280869245-2786-1-git-send-email-ddaney@caviumnetworks.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> This is a small cleanup that could either be folded into the original
> 3/5 or applied in addition to it.

I've folded it into 3/5.  Thanks!

  Ralf
