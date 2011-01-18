Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751751Ab1ARNEg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 08:04:36 -0500
Received: from mxs.selfip.ru ([77.221.143.26]:34944 "EHLO mxs.selfmail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751597Ab1ARNEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 08:04:22 -0500
X-ACL-SPF: 
Subject: Re: [ANN] ulatencyd 0.3.1
From: Vasiliy G Tolstov <v.tolstov@selfip.ru>
Reply-To: v.tolstov@selfip.ru
To: Daniel Poelzleithner <poelzi@poelzi.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4D357204.3090505@poelzi.org>
References: <4D357204.3090505@poelzi.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Selfip.Ru
Date: Tue, 18 Jan 2011 16:03:34 +0300
Message-ID: <1295355814.24148.4.camel@mobile>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 8bit
X-ACL-DATA: Invalid Message-Id
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-18 at 11:57 +0100, Daniel Poelzleithner wrote:
> Hi all,
> 
> I'm happy to announce the release of ulatencyd 0.3.1
> 
> What is it ?
> ============
> 
> ulatencyd is a scriptable daemon which constantly optimises the Linux
> kernel for best user experience.
> The default configuration tries reduce the latency for a typical desktop
> system and protects the system from malicious processes/groups.
> With a different configuration all other types of systems can be
> adjusted as well.
> 
> Website: <https://github.com/poelzi/ulatencyd/>
> 
> • Ubuntu PPA: <https://launchpad.net/~poelzi/+archive/ulatencyd-stable>
> • Latest Release:
> <https://github.com/downloads/poelzi/ulatencyd/ulatencyd-0.3.1.tar.gz>
> 
> 
> What's new in 0.3 (very short version)?
> =======================================
> 
> • X-Server plugin which monitors the active windows and gives more
>   priority to the recently active windows.
> • Full scripted scheduler with flexible configuration that allows easy
>   adjustment of the resulting cgroups and parameters.
> • Protection rules against common cases of memory shortage, also known
>   as the swap of death (even without swap).
> • Scheduler configuration for desktop systems
> • Fast C core with Lua embedding. Intelligent caching to reduce the
>   load on filter rules and scheduler.
> • Very detailed API for system inspection and adjustment.
> • Rudimentary Rules for popular Desktop Environments KDE & Gnome
> 
> 
> Does it work ?
> ==============
> 
> Yes. Of course it is possible to still cause a swap of death or overload
> the system so much, that it starts to get lag. But typical cases get
> caught by the current rules. A make -j 50 of the linux kernel
> on my dual core machine with 4 GB ram let me still work on the machine
> quite well, but a make -j 80 still locks it down for like 4 minutes.
> This is most likely because the heavy swapping done on the isolation
> groups (their main memory usage is restraint). This may be fixed by
> using the blockio subsystem, but this is not used yet. Planned for the
> next version.
> 
> 
> kind regards
>  Daniel Poelzleithner
> 

Hello! May be offtopic, bu does ulatencyd works well together with
systemd init system?


