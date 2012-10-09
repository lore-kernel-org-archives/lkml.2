Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab2JIUGm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 16:06:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55135 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab2JIUGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 16:06:39 -0400
Date: Tue, 9 Oct 2012 13:06:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org,
        Ed Cashin <ecashin@coraid.com>, Christopher Li <sparse@chrisli.org>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] linux/compiler.h: Add __must_hold macro for functions
 called with a lock held
Message-Id: <20121009130637.5e61078f.akpm@linux-foundation.org>
In-Reply-To: <20121008020610.GA9197@leaf>
References: <20121008020610.GA9197@leaf>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 7 Oct 2012 19:06:10 -0700
Josh Triplett <josh@joshtriplett.org> wrote:

> linux/compiler.h has macros to denote functions that acquire or release
> locks, but not to denote functions called with a lock held that return
> with the lock still held.  Add a __must_hold macro to cover that case.

hum.  How does this work?  Any code examples and sample sparse output? 
Does it apply to all lock types, etc?

IOW, where is all this stuff documented?

