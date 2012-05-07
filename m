Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256Ab2EGFq2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 01:46:28 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35115 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab2EGFq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 01:46:26 -0400
Date: Mon, 7 May 2012 06:46:16 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Nick Piggin <npiggin@kernel.dk>, Andi Kleen <ak@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 3/3] brlocks/lglocks: turn into functions
Message-ID: <20120507054616.GG22082@ZenIV.linux.org.uk>
References: <87ehtf3lqh.fsf@rustcorp.com.au>
 <20120227155338.7b5110cd.akpm@linux-foundation.org>
 <20120228112422.GC11324@alboin.amr.corp.intel.com>
 <87ipijzfwn.fsf@rustcorp.com.au>
 <20120420112149.GH25458@amd.local0.net>
 <87sjfcfynb.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sjfcfynb.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2012 at 01:09:04PM +0930, Rusty Russell wrote:
> On Fri, 20 Apr 2012 21:21:49 +1000, Nick Piggin <npiggin@kernel.dk> wrote:
> > This still not merged?
> 
> No, I've been away.  I've put it in -next for tomorrow, though I'm not
> sure what the best way to get it to Linus next merge window.

Resend and I'll pick it.
