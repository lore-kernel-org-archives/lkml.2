Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933198Ab2GFKyd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 06:54:33 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:35449 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932831Ab2GFKyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 06:54:31 -0400
Date: Fri, 6 Jul 2012 12:54:25 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/5] uprobes: write_opcode() cleanups
Message-ID: <20120706105425.GA31587@gmail.com>
References: <20120624145936.GA23269@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120624145936.GA23269@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Oleg Nesterov <oleg@redhat.com> wrote:

> Hello,
> 
> write_opcode() cleanups resend + new minor fix.
> 
> Changes:
> 
> 	- document the new argument in 2/5.
> 
> 	- drop the buggy 5/5, thanks Anton for your quick nack.
> 	  Probably I'll return to this later, I have another reason
> 	  for this change.
> 
> 	- so this 5/5 is new.
> 
> Srikar, please add your acks unless you have some objections.

Just wondering what's the review status of patches #1-#4?

I'll skip #5 based on Oleg's request, but the others are looking 
good.

Thanks,

	Ingo
