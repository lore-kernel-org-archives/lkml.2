Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532Ab2K0OUp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 09:20:45 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:54832
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751588Ab2K0OUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 09:20:44 -0500
Date: Tue, 27 Nov 2012 09:20:35 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Howells <dhowells@redhat.com>,
        Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Tony Luck <tony.luck@intel.com>, Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH] perf tools: fix build for various architectures
Message-ID: <20121127142035.GA30995@bombadil.infradead.org>
References: <1354018591-26656-1-git-send-email-mark.rutland@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354018591-26656-1-git-send-email-mark.rutland@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 12:16:31PM +0000, Mark Rutland wrote:
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Kyle McMartin <kyle@mcmartin.ca>

Looks obviously right.

Acked-by: Kyle McMartin <kyle@mcmartin.ca>

> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Will Deacon <will.deacon@arm.com>
