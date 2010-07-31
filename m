Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717Ab0GaFpf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 01:45:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47457 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752855Ab0GaFpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 01:45:32 -0400
Date: Sat, 31 Jul 2010 01:39:19 -0400
From: Chuck Ebbert <cebbert@redhat.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Prasad <prasad@linux.vnet.ibm.com>
Subject: Re: [070/140] x86: Send a SIGTRAP for user icebp traps
Message-ID: <20100731013919.36c26238@katamari>
In-Reply-To: <20100730173109.035373791@clark.site>
References: <20100730173205.GA22581@kroah.com>
	<20100730173109.035373791@clark.site>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Jul 2010 10:30:35 -0700
Greg KH <gregkh@suse.de> wrote:

> 2.6.33-stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> 
> From: Frederic Weisbecker <fweisbec@gmail.com>
> 
> commit a1e80fafc9f0742a1776a0490258cb64912411b0 upstream.
> 

This backport will not work. Instead of fixing up the context of this 
patch to make it apply, commit 40f9249a73f6c251adea492b1c3d19d39e2a9bda 
("x86/debug: Clear reserved bits of DR6 in do_debug()") should be 
applied first, followed by an unmodified version of this commit.
