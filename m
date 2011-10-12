Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575Ab1JLQVN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 12:21:13 -0400
Received: from www.hansjkoch.de ([178.63.77.200]:34083 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753045Ab1JLQVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 12:21:12 -0400
Date: Wed, 12 Oct 2011 18:20:54 +0200
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>, gregkh@suse.de, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UIO: Allow a UIO driver to override the default pgprot
 when we mmap
Message-ID: <20111012162053.GF21852@local>
References: <1318430616-20351-1-git-send-email-galak@kernel.crashing.org>
 <20111012153536.GC21852@local>
 <AEAF26D0-640A-4DD2-82FE-B3BD02662EEC@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AEAF26D0-640A-4DD2-82FE-B3BD02662EEC@kernel.crashing.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 11:08:20AM -0500, Kumar Gala wrote:
> 
> On Oct 12, 2011, at 10:35 AM, Hans J. Koch wrote:
> 
> > On Wed, Oct 12, 2011 at 09:43:36AM -0500, Kumar Gala wrote:
> >> For some devices the default behavior of pgprot_noncached is not
> >> the correct flags for the address space.
> > 
> > For what devices? Can you give a real world usecase where this is needed?
> > 
> > Thanks,
> > Hans
> 
> In the Freescale Networking devices we have a coherent memory interface to our HW queuing system.  In that case we want to change the pgprot() to be cache-able instead of non-cached.

Could you please post the kernel part of that driver?

Thanks,
Hans
