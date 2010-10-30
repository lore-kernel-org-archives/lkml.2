Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab0J3OsS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 10:48:18 -0400
Received: from tex.lwn.net ([70.33.254.29]:41114 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753714Ab0J3OsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 10:48:16 -0400
Date: Sat, 30 Oct 2010 08:48:13 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] VIA Chrome integrated camera controller driver includes
 headers multiple times
Message-ID: <20101030084813.3581ea7e@bike.lwn.net>
In-Reply-To: <alpine.LNX.2.00.1010301527580.7979@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1010301527580.7979@swampdragon.chaosbits.net>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Oct 2010 15:32:32 +0200 (CEST)
Jesper Juhl <jj@chaosbits.net> wrote:

> The VIA Chrome integrated camera controller driver includes both 
> 'linux/pci.h' and 'linux/device.h' twice. This gets rid of the duplicates.

Well, you see...I have teenage children.  So I've gotten very much used
to the idea that you have to ask for anything at *least* twice have any
chance of it actually happening.  Beyond that, the VIA controller has
certain adolescent behavior patterns of its own...watch out when it's
in a bad mood...so I just kind of fell into the habit of insisting.
Even then, I've been known to check with gcc -E to be *sure* it got
included.

Seriously, though, I'm not sure how that happened.   Obviously:

	Acked-by: Jonathan Corbet <corbet@lwn.net>

Thanks,

jon
