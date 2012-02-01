Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563Ab2BAWzq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 17:55:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53150 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463Ab2BAWzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 17:55:45 -0500
Date: Wed, 1 Feb 2012 14:55:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Milton Miller <miltonm@bga.com>, arjanvandeven@gmail.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: smp: Start up non-boot CPUs asynchronously
Message-Id: <20120201145544.f3a4cc64.akpm@linux-foundation.org>
In-Reply-To: <20120131082439.575978c0@infradead.org>
References: <20120130205444.22f5e26a@infradead.org>
	<20120131125232.GD4408@elte.hu>
	<20120131054155.371e8307@infradead.org>
	<20120131143130.GF13676@elte.hu>
	<20120131072216.1ce78e50@infradead.org>
	<20120131161207.GA18357@elte.hu>
	<20120131082439.575978c0@infradead.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jan 2012 08:24:39 -0800
Arjan van de Ven <arjan@infradead.org> wrote:

> The starting of the "not first" CPUs actually takes a lot of boot time
> of the kernel... upto "minutes" on some of the bigger SGI boxes.

Where is all this time being spent?
