Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292Ab0JOOoZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 10:44:25 -0400
Received: from cantor.suse.de ([195.135.220.2]:32917 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754844Ab0JOOoY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 10:44:24 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: Process to push changes to include/linux/types.h
Date: Fri, 15 Oct 2010 16:44:21 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.36-rc7+; KDE/4.3.5; i686; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jan Engelhardt <jengelh@medozas.de>, Eric Paris <eparis@redhat.com>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        davem@davemloft.net
References: <1287084892.3367.18.camel@dhcp231-212.rdu.redhat.com> <201010151215.49392.agruen@suse.de> <20101015142617.GB25620@basil.fritz.box>
In-Reply-To: <20101015142617.GB25620@basil.fritz.box>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010151644.21794.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 October 2010 16:26:17 Andi Kleen wrote:
> > 64-bit values align to 4-byte boundaries on some 32-bit architectures like
> > x86 
> AFAIK it's only on x86, no other architecture made this mistake in their
> 32bit ABI. But of course x86 is kind of important ...

I don't know of any other examples; all the architectures I tried "got it 
right" except x86.

Andreas
