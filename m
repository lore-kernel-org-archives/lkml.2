Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755Ab1KXUAR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 15:00:17 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64176 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017Ab1KXUAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 15:00:16 -0500
Date: Thu, 24 Nov 2011 12:00:09 -0800
From: Tejun Heo <htejun@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Li Zefan <lizf@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org,
        Tomasz Buchert <tomasz.buchert@inria.fr>,
        Paul Menage <paul@paulmenage.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] cgroup_freezer: fix freezing groups with stopped tasks
Message-ID: <20111124200009.GB6735@google.com>
References: <1321480234-29241-1-git-send-email-mhocko@suse.cz>
 <20111121230709.GR25776@google.com>
 <4ECB06D2.6060106@cn.fujitsu.com>
 <20111122022118.GT25776@google.com>
 <20111122090522.GA26768@tiehlicka.suse.cz>
 <20111122153948.GE322@google.com>
 <20111122154748.GF322@google.com>
 <20111124100454.GE26036@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111124100454.GE26036@tiehlicka.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 24, 2011 at 11:04:54AM +0100, Michal Hocko wrote:
> On Tue 22-11-11 07:48:06, Tejun Heo wrote:
> > On Tue, Nov 22, 2011 at 07:39:48AM -0800, Tejun Heo wrote:
> > > > Signed-off-by: Michal Hocko <mhocko@suse.cz>
> > > > Cc: Tomasz Buchert <tomasz.buchert@inria.fr>
> > > > Cc: Paul Menage <paul@paulmenage.org>
> > > > Cc: Li Zefan <lizf@cn.fujitsu.com>
> > > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > > Cc: Tejun Heo <htejun@gmail.com>
> > > 
> > > Applying to cgroup/for-3.2-fixes.
> > 
> > I'll apply the original version in cgroup/for-3.2-fixes and deal with
> > conflict once pm-freezer branch is merged.  
> 
> Are you going to push this to the stable trees as well, or should I do
> it?

Tagged w/ stable.  Will push it upstream next week and the next stable
release will pick it up.

Thanks.

-- 
tejun
