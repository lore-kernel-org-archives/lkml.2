Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253Ab2GWNO2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 09:14:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48310 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991Ab2GWNO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 09:14:26 -0400
Date: Mon, 23 Jul 2012 08:14:19 -0500
From: Serge Hallyn <serge.hallyn@canonical.com>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, lwn@lwn.net,
        "criu@openvz.org" <criu@openvz.org>, users@openvz.org,
        cgroups mailinglist <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: [Announce] Checkpoint-restore tool v0.1
Message-ID: <20120723131419.GB4923@sergelap>
References: <500D09C9.7060903@parallels.com>
 <500D1116.7070301@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <500D1116.7070301@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Pavel Emelyanov (xemul@parallels.com):
> Fixing the bogus containers@ ml and adding cgroups@ one. Sorry :(
> 
> == Original message ==
> 
> Hi!
> 
> I'm glad to announce the first release of the checkpoint-restore tool.
> 
> 
> This project is an attempt to implement the checkpoint-restore functionality
> for processes and containers without driving too much code into the kernel tree,
> but putting there "various oddball helper code" instead.
> 
> The tool can already be used for checkpointing and restoring various individual
> applications. And the greatest thing about this so far is that most of the below
> functionality has the required kernel support in the recently released v3.5!
> 
> So, we support now
> 
> * x86_64 architecture
> * process' linkage
> * process groups and sessions (without ttys though :\ )
> * memory mappings of any kind (shared, file, etc.)
> * threads
> * open files (shared between tasks and partially opened-and-unlinked)
> * pipes and fifos with data
> * unix sockets with packet queues contents
> * TCP and UDP sockets (TCP connections support exists, but needs polishing)
> * inotifies, eventpoll and eventfd
> * tasks' sigactions setup, credentials and itimers
> * IPC, mount and PID namespaces
> 
> Though namespaces support is in there, we do not yet support an LXC container c/r,
> but we're close to it :)
> 
> 
> I'd like to thank everyone who took part in new kernel APIs discussions, the
> feedback was great! Special thanks goes to Linus for letting the kernel parts
> in early, instead of making them sit out of tree till becoming stable enough.
> 
> 
> Tarball with the tool sources is at
> 
>   http://download.openvz.org/criu/crtools-0.1.tar.bz2
> 
> The git repo is at
> 
>   http://git.criu.org/
> 
> And some sort of docs growing at
> 
>   http://criu.org/
> 
> 
> There are still things for which we don't have the kernel support merged (SysVIPC
> and various anon file descriptors, i.e. inotify, eventpoll, eventfd) yet. We have
> the kernel branch with the stuff applied available at
> 
>   https://github.com/cyrillos/linux-2.6.git
> 
> 
> Thanks,
> Pavel

Awesome - thanks, Pavel, and congratulations :)  I'll have to give it a
spin as soon as I get a chance.
