Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925Ab0IONXh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 09:23:37 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:59336 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113Ab0IONXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 09:23:35 -0400
Date: Wed, 15 Sep 2010 22:53:24 +0930
From: Christopher Yeoh <cyeoh@au1.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org
Subject: Re: [RFC][PATCH] Cross Memory Attach
Message-ID: <20100915225324.60280a50@lilo>
In-Reply-To: <20100915081653.GA16406@elte.hu>
References: <20100915104855.41de3ebf@lilo>
	<20100915080235.GA13152@elte.hu>
	<20100915081653.GA16406@elte.hu>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Sep 2010 10:16:53 +0200
Ingo Molnar <mingo@elte.hu> wrote:
> 
> btw., how does OpenMPI signal the target tasks that something
> happened to their address space - is there some pipe/socket
> side-channel, or perhaps purely based on flags in the modified memory
> areas, which are polled?

The shared memory btl signals through shared memory, though when
threading is enabled (I think its mostly used with threading support
disabled) in OpenMPI there is also signalling done through a pipe.

Regards,

Chris
-- 
cyeoh@au.ibm.com
