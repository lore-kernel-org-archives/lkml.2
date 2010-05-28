Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757582Ab0E1JOD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 05:14:03 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53869 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028Ab0E1JN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 05:13:59 -0400
Date: Fri, 28 May 2010 11:13:54 +0200
From: Andi Kleen <andi@firstfloor.org>
To: TAMUKI Shoichi <tamuki@linet.gr.jp>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Anton Blanchard <anton@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Andy Green <andy@warmcat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] panic: keep blinking in spite of long spin timer mode
Message-ID: <20100528091354.GA16587@basil.fritz.box>
References: <201005272156.AA00412@tamuki.linet.gr.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201005272156.AA00412@tamuki.linet.gr.jp>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 28, 2010 at 06:56:45AM +0900, TAMUKI Shoichi wrote:
> To keep panic_timeout accuracy when running under a hypervisor, the
> current implementation only spins on long time (1 second) calls to
> mdelay.  That brings a good effect, but we must give up blinking even
> if we have a panic_blink.
> 
> This patch keeps blinking in spite of long spin timer mode.
> 
> We now have new kernel parameter (panic_longspin) to enable long spin
> timer mode when kernel panics.  This is to be used when running under
> a hypervisor (default is disable).

Sorry I didn't understand the problem based on your description.

What exactly is the problem with the current code under your
hypervisor? 

New parameters for this are probably not the right answer,
who would figure out when to set them.

-Andi
