Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999Ab0CYAIx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 20:08:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53285 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753906Ab0CYAIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 20:08:52 -0400
Date: Wed, 24 Mar 2010 17:07:04 -0400
From: Andrew Morton <akpm@linux-foundation.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>, Thomas Gleixner <tglx@linutronix.de>,
       jblunck@suse.de, Alan Cox <alan@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT, RFC] Killing the Big Kernel Lock
Message-Id: <20100324170704.7ef8b9c1.akpm@linux-foundation.org>
In-Reply-To: <201003242240.54907.arnd@arndb.de>
References: <201003242240.54907.arnd@arndb.de>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Mar 2010 22:40:54 +0100 Arnd Bergmann <arnd@arndb.de> wrote:

> I've spent some time continuing the work of the people on Cc and many others
> to remove the big kernel lock from Linux

<looks inside ptrace.c>

Seems that there might be a few tricksy bits in here.  Please do push
at least the non-obvious parts out to the relevant people.

It'd be interesting to see the overall diffstat?
