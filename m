Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933958Ab2AKUXb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 15:23:31 -0500
Received: from lo.gmane.org ([80.91.229.12]:47442 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933921Ab2AKUXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 15:23:11 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Mantas <grawity@gmail.com>
Subject: Re: 3.2rc7 rcu_preempt stalls and tasks blocked.
Date: Wed, 11 Jan 2012 22:22:40 +0200
Message-ID: <jekr2s$c9c$1@dough.gmane.org>
References: <bcf.4ef5dd08.61f72@roo.daria.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 78-60-211-195.static.zebra.lt
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111224 Thunderbird/9.0.1
In-Reply-To: <bcf.4ef5dd08.61f72@roo.daria.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-12-24 16:09, Jonathan Hudson wrote:
> Ever since 3.1, I've been experiencing rcu_preempt stalls, tasks
> blocked and subsequent lock ups on an eeepc 901. Judging by the thread
> <https://bugs.archlinux.org/task/26847> on the Arch forums, this is not
> an uncommon experience. 

Can confirm on ASUS K52JT, using 3.2 (Arch Linux) and various git builds
starting around 3.2-rc6/7. Appears to be caused by heavier wireless
network activity (ath9k, Atheros AR9285, open network, IPv4 & IPv6),
such as BitTorrent -- although not by ordinary HTTP or such. Other posts
in the Arch bug report say having ipv6 loaded/enabled is causing the
problem.

During the lockup, accessing certain files in /proc (can't remember all,
but /proc/*/mounts and /proc/*/cgroup included) causes the process to
hang; same when running `ip`, `iwconfig` and related tools. Often (but
not always), killing NetworkManager makes everything work again.

Hoping for a fix someday.

-- 
Mantas M.

