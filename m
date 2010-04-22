Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241Ab0DVUxA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:53:00 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:43210 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754975Ab0DVUw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 16:52:56 -0400
Date: Thu, 22 Apr 2010 22:52:47 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [139/139] MIPS: Sibyte: Fix M3 TLB exception handler
 workaround.
Message-ID: <20100422205247.GA16906@Chamillionaire.breakpoint.cc>
References: <20100422195715.GA25490@kroah.com>
 <20100422195419.224841637@kvm.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20100422195419.224841637@kvm.kroah.org>
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH | 2010-04-22 12:55:16 [-0700]:

>2.6.33-stable review patch.  If anyone has any objections, please let us know.
Greg, you picked this patch without "MIPS: uasm: Add OR instruction"
Please drop it _or_ add both. This patch alone will break compilation of
the whole MIPS tree.

Sebastian
