Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139Ab0FISqq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 14:46:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48046 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758112Ab0FISqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 14:46:45 -0400
Date: Wed, 9 Jun 2010 11:46:13 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Stephen Hemminger <shemminger@vyatta.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] floppy: cleanup patches
In-Reply-To: <20100609183449.110905403@vyatta.com>
Message-ID: <alpine.LFD.2.00.1006091144120.4506@i5.linux-foundation.org>
References: <20100609183449.110905403@vyatta.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 9 Jun 2010, Stephen Hemminger wrote:
>
> When going through floppy driver addressing some of the timing
> bugs, I also saw these leftover things that ought to be cleaned up.

Ack on them all as far as I'm concerned. I suspect the _real_ bugs in 
floppy.c are about various paths not holding the floppy_lock spinlock, but 
the patches all look fine and certainly don't make anything worse.

Mind re-sending them after 2.6.35, though? (Or maybe somebody like Greg 
wants to queue them up in their drievr trees)

			Linus
