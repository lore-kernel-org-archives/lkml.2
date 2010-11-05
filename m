Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523Ab0KENnz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 09:43:55 -0400
Received: from mail.sdinet.de ([78.47.32.153]:53096 "EHLO mail.sdinet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751757Ab0KENny (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 09:43:54 -0400
Date: Fri, 5 Nov 2010 14:42:59 +0100 (CET)
From: Sven-Haegar Koch <haegar@sdinet.de>
To: Asbjoern Sloth Toennesen <asbjorn@asbjorn.biz>
cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, debian-kernel@lists.debian.org
Subject: Re: [PATCH] kbuild, deb-pkg: select userland architecture based on
 UTS_MACHINE
In-Reply-To: <1288963808-7057-1-git-send-email-asbjorn@asbjorn.biz>
Message-ID: <alpine.DEB.2.02.1011051437500.13287@aurora.sdinet.de>
References: <4CD406C7.8090801@asbjorn.biz> <1288963808-7057-1-git-send-email-asbjorn@asbjorn.biz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Nov 2010, Asbjoern Sloth Toennesen wrote:

> Instead of creating the debian package for the compiling userland,
> create it for a userland matching the kernel thats being compiled.

> Eg. with this patch the following make command:
> 
> 	make ARCH=i386 deb-pkg
> 
> will output an i386 Debian package instead of an amd64 one,
> when run on an amd64 machine.

How do I either select a differnet package-arch or reverse to the 
current way?

I am right now using 'make ARCH=x86_64 deb-pkg' on a 32bit userspace
environment running with a 64bit kernel, wanting to create packages to 
be installed in this i386 arch.

(As I want 64bit support where possible (mostly for AES-NI support in 
dm-crypt), but don't have the time available to do a complete userspace 
reinstall and reconfiguration)

c'ya
sven-haegar

-- 
Three may keep a secret, if two of them are dead.
- Ben F.
