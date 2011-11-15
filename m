Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495Ab1KOW32 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 17:29:28 -0500
Received: from gate.crashing.org ([63.228.1.57]:60028 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754749Ab1KOW31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 17:29:27 -0500
Message-ID: <1321396146.3170.11.camel@pasglop>
Subject: Re: [RFC PATCH 0/2] powerpc: CPU cache op cleanup
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Kyle Moffett <Kyle.D.Moffett@boeing.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        galak@kernel.crashing.org, scottwood@freescale.com,
        B04825@freescale.com, paul.gortmaker@windriver.com
Date: Wed, 16 Nov 2011 09:29:06 +1100
In-Reply-To: <1321324332-22964-1-git-send-email-Kyle.D.Moffett@boeing.com>
References: <1320986410.21206.48.camel@pasglop>
	 <1321324332-22964-1-git-send-email-Kyle.D.Moffett@boeing.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-14 at 21:32 -0500, Kyle Moffett wrote:
> Unfortunately, I've been staring at PPC asm for long enough that I
> have a migraine headache and I'm going to have to stop here for now.
> If somebody else wants to tackle fixing up the 32-bit copy_page() and
> __copy_tofrom_user() routines it would be highly appreciated. 

Yeah that's the one everybody's avoiding :-)

What about my idea of instead compiling it multiple times with a
different size and fixing up the branch to call the right one ?

Cheers,
Ben.


