Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290Ab1KVPsP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 10:48:15 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:45620 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756789Ab1KVPsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 10:48:12 -0500
Date: Tue, 22 Nov 2011 07:48:06 -0800
From: Tejun Heo <htejun@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Li Zefan <lizf@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org,
        Tomasz Buchert <tomasz.buchert@inria.fr>,
        Paul Menage <paul@paulmenage.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] cgroup_freezer: fix freezing groups with stopped tasks
Message-ID: <20111122154748.GF322@google.com>
References: <1321480234-29241-1-git-send-email-mhocko@suse.cz>
 <20111121230709.GR25776@google.com>
 <4ECB06D2.6060106@cn.fujitsu.com>
 <20111122022118.GT25776@google.com>
 <20111122090522.GA26768@tiehlicka.suse.cz>
 <20111122153948.GE322@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111122153948.GE322@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 07:39:48AM -0800, Tejun Heo wrote:
> > Signed-off-by: Michal Hocko <mhocko@suse.cz>
> > Cc: Tomasz Buchert <tomasz.buchert@inria.fr>
> > Cc: Paul Menage <paul@paulmenage.org>
> > Cc: Li Zefan <lizf@cn.fujitsu.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Tejun Heo <htejun@gmail.com>
> 
> Applying to cgroup/for-3.2-fixes.

I'll apply the original version in cgroup/for-3.2-fixes and deal with
conflict once pm-freezer branch is merged.  Li, can you please ack
this?

Thank you.

-- 
tejun
