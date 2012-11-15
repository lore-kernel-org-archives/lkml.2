Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804Ab2KOPap (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 10:30:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45810 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753758Ab2KOPao (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 10:30:44 -0500
Date: Thu, 15 Nov 2012 16:30:43 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Ulrich Windl <Ulrich.Windl@rz.uni-regensburg.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Q: using cgroups in real life
Message-ID: <20121115153043.GA24131@dhcp22.suse.cz>
References: <50A3B0A6020000A10000D757@gwsmtp1.uni-regensburg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50A3B0A6020000A10000D757@gwsmtp1.uni-regensburg.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 14-11-12 14:54:30, Ulrich Windl wrote:
> Hi!
> 
> I have a question on cgroups (as of Linux 3.0):
> The concept is to mount a filesystem, and configure cgroups through
> it. This implies that all the files belong to root (or maybe some
> other fixed user).

Have a look at libcgroup package - cgconfig in particular.

> AFAIK, you can chmod() and chown() files, but these bits are only kept
> in the i-node cache, so they may change at any time.

Not true they will live with the files

> I think this is bad, because if you want to allow users to limit
> (maybe memory usage) by using some predefined cgroup, the user
> needs at least partial write access to that cgroup (to add the
> PID). Probably this also means the user could add any PID (even those
> processes not owned by him).

man cgconfig.conf

[...]

I would suggest asking this kind of questions at libcgroup
libcg-devel@lists.sourceforge.net mailing list as it is more focused on
the cgroups usage.
-- 
Michal Hocko
SUSE Labs
