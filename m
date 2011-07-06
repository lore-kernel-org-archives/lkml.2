Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756377Ab1GFVJL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 17:09:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47092 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756332Ab1GFVJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 17:09:09 -0400
Date: Wed, 6 Jul 2011 14:08:56 -0700
From: Greg KH <gregkh@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Kevin Hilman <khilman@ti.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, Paul Walmsley <paul@pwsan.com>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH 0/5 v1] PM / Domains: Generic PM domains improvements
Message-ID: <20110706210856.GA1215@suse.de>
References: <201107062248.35586.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201107062248.35586.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 06, 2011 at 10:48:35PM +0200, Rafael J. Wysocki wrote:
> Hi,
> 
> For the last few days I've been working on modifications of the generic
> PM domains code allowing .start_device()/.stop_device() and drivers'
> .runtime_suspend()/.runtime_resume() callbacks to execute things like
> pm_runtime_resume() for other devices in the same PM domain safely
> without deadlocking (the original motivation was a console driver on
> shmobile that pm_runtime_get_*()/pm_runtime_put_*() are called for from
> the other devices' .runtime_suspend()/.runtime_resume() callbacks).
> 
> I think I solved that problem, but in the process I found a few places
> where fixes and/on improvements were necessary.  The patches in this
> series address those issues.  They are on top of the branch at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git pm-domains
> 
> Patches [1-2/5] are regarded as 3.1 material, the others not necessarily,
> but I'd like to push them for 3.1 too if there are no complaints.

No complaints from me, looks nice.

greg k-h
