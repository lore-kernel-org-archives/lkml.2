Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758067Ab0FISYF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 14:24:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2499 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752648Ab0FISYC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 14:24:02 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FRV: Implement the GDB remote protocol 'p' command to retrieve a register
References: <20100609161909.18222.78028.stgit@warthog.procyon.org.uk>
	<alpine.LFD.2.00.1006090945531.4506@i5.linux-foundation.org>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Wed, 09 Jun 2010 14:23:25 -0400
In-Reply-To: <alpine.LFD.2.00.1006090945531.4506@i5.linux-foundation.org> (Linus Torvalds's message of "Wed, 9 Jun 2010 09:48:06 -0700 (PDT)")
Message-ID: <y0mfx0wysiq.fsf@fche.csb>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

>> Implement the GDB remote protocol 'p' command to retrieve a single register
>> value.
>
> Is there any value to this? [...]

Sure, much less data to transfer across a slowish serial link.

- FChE
