Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933191Ab2HXUC2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 16:02:28 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:57511 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932864Ab2HXUCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 16:02:20 -0400
Date: Sat, 25 Aug 2012 00:02:16 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Brian Gerst <brgerst@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pekka Enberg <penberg@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Ian Campbell <ian.campbell@citrix.com>
Subject: Re: [RFC] x86: drop unnecessary kernel_eflags variable from 64 bit
Message-ID: <20120824200216.GB31628@moon>
References: <20120824195847.GA31628@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120824195847.GA31628@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2012 at 11:58:47PM +0400, Cyrill Gorcunov wrote:
...
> 
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>

Crap, forgot to CC Ian. Sorry.
