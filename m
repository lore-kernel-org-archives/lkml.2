Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758061Ab0FIS3d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 14:29:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55420 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751470Ab0FIS3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 14:29:32 -0400
Date: Wed, 9 Jun 2010 11:29:19 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Frank Ch. Eigler" <fche@redhat.com>
cc: David Howells <dhowells@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FRV: Implement the GDB remote protocol 'p' command to
 retrieve a register
In-Reply-To: <y0mfx0wysiq.fsf@fche.csb>
Message-ID: <alpine.LFD.2.00.1006091126590.4506@i5.linux-foundation.org>
References: <20100609161909.18222.78028.stgit@warthog.procyon.org.uk> <alpine.LFD.2.00.1006090945531.4506@i5.linux-foundation.org> <y0mfx0wysiq.fsf@fche.csb>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 9 Jun 2010, Frank Ch. Eigler wrote:
> 
> Sure, much less data to transfer across a slowish serial link.

Umm. Or more? If you look at one register, you tend to look at several. 
And we're not exactly talking kilobytes here.

Anyway, the existing patch is certainly easy to make a judgment on: it's 
not a regression fix but a new feature, so I'm not applying it. I was 
suggesting _making_ it a regression fix, but I really don't care.

		Linus
