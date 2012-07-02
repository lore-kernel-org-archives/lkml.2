Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932914Ab2GBJyM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 05:54:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:33461 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932717Ab2GBJyL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 05:54:11 -0400
Message-ID: <1341222838.23484.1.camel@twins>
Subject: Re: [PATCH -v2 0/2] x86, microcode: Reload ucode only per-system
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Borislav Petkov <bp@amd64.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        X86-ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>
Date: Mon, 02 Jul 2012 11:53:58 +0200
In-Reply-To: <20120630174503.GA24854@aftab.osrc.amd.com>
References: <1340280437-7718-1-git-send-email-bp@amd64.org>
	 <20120630174503.GA24854@aftab.osrc.amd.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-06-30 at 19:45 +0200, Borislav Petkov wrote:
> Assuming there are no more objections to those, can we get them into,
> say, tip:x86/microcode for a wider, linux-next testing?
> 
> Peter's stuff could go there too or through the perf tree - it's kinda
> arbitrary though. 

I've got them queued as such, Ingo's just hasn't gotten around to
picking things up yet. Let me see if today is a good day for this.. :-)
