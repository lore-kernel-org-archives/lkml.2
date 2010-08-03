Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757701Ab0HCU0g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 16:26:36 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:43689 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757650Ab0HCU0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 16:26:35 -0400
Date: Tue, 3 Aug 2010 21:26:07 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: David Daney <ddaney@caviumnetworks.com>
Cc: linux-mips@linux-mips.org, ananth@in.ibm.com,
        anil.s.keshavamurthy@intel.com, davem@davemloft.net,
        masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org,
        hschauhan@nulltrace.org
Subject: Re: [PATCH 1/5] MIPS: Define regs_return_value()
Message-ID: <20100803202607.GA25233@linux-mips.org>
References: <1280859742-26364-1-git-send-email-ddaney@caviumnetworks.com>
 <1280859742-26364-2-git-send-email-ddaney@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280859742-26364-2-git-send-email-ddaney@caviumnetworks.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 03, 2010 at 11:22:18AM -0700, David Daney wrote:

> +#define regs_return_value(regs) ((regs)->regs[2])

This will probably only work if the argument happens to be "regs" otherwise
the things will likely go splat.

  Ralf
