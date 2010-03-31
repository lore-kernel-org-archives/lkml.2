Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758298Ab0CaWjF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 18:39:05 -0400
Received: from gate.crashing.org ([63.228.1.57]:38829 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757597Ab0CaWjC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 18:39:02 -0400
Subject: Re: start_kernel(): bug: interrupts were enabled early
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, Yinghai Lu <yinghai@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Rabin Vincent <rabin@rab.in>,
       lkml <linux-kernel@vger.kernel.org>, penberg@cs.helsinki.fi,
       linux-arch@vger.kernel.org
In-Reply-To: <4BB3C540.9000405@zytor.com>
References: <20100325194100.GA2364@debian>
	 <20100331134048.da4e35a7.akpm@linux-foundation.org>
	 <4BB3B4DB.7040904@kernel.org> <20100331210145.GB32165@parisc-linux.org>
	 <4BB3B8FC.1020608@zytor.com> <20100331211754.GC32165@parisc-linux.org>
	 <alpine.DEB.2.00.1003311640410.30456@router.home>
	 <20100331215411.GB17715@flint.arm.linux.org.uk>
	 <4BB3C540.9000405@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Apr 2010 09:37:51 +1100
Message-ID: <1270075071.7101.79.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-31 at 14:57 -0700, H. Peter Anvin wrote:
> 
> The question still remains what the incremental cost is of doing
> irqsave/irqrestore. 

The only other option is to have local_irq_enable() check a global
(system_state ?) before enabling. Almost as gross ...

Cheers,
Ben.


