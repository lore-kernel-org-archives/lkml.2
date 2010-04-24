Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035Ab0DXSiq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 14:38:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45435 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751179Ab0DXSip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 14:38:45 -0400
Date: Sat, 24 Apr 2010 11:36:52 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
       Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@ZenIV.linux.org.uk>,
       Jan Blunck <jblunck@suse.de>, Ingo Molnar <mingo@elte.hu>,
       John Kacur <jkacur@redhat.com>
Subject: Re: [GIT PULL v2] Preparation for BKL'ed ioctl removal
In-Reply-To: <20100424152542.GD5545@nowhere>
Message-ID: <alpine.LFD.2.00.1004241135460.3739@i5.linux-foundation.org>
References: <1271390201-20431-1-git-send-regression-fweisbec@gmail.com> <1271897282-11207-1-git-send-regression-fweisbec@gmail.com> <20100424152542.GD5545@nowhere>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 24 Apr 2010, Frederic Weisbecker wrote:
> 
> This is the second version of this pull request and you don't seem to be
> pulling it either.

I don't see the point, frankly. Especially not outside the merge window, 
but quite frankly, I don't see it in general. The whole thing seems to be 
designed to be inconvenient, and to have a config option that I 
fundamentally don't believe in (CONFIG_BKL).

		Linus
