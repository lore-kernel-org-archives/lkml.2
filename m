Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495Ab1KVP4u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 10:56:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51876 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757356Ab1KVP4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 10:56:48 -0500
Date: Tue, 22 Nov 2011 16:56:45 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <htejun@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org,
        Tomasz Buchert <tomasz.buchert@inria.fr>,
        Paul Menage <paul@paulmenage.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] cgroup_freezer: fix freezing groups with stopped tasks
Message-ID: <20111122155645.GC26768@tiehlicka.suse.cz>
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
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 22-11-11 07:39:48, Tejun Heo wrote:
> Hello, Michal.
> 
> On Tue, Nov 22, 2011 at 10:05:22AM +0100, Michal Hocko wrote:
> > I am not sure which BUG_ON you have in mind.
> > update_if_frozen:
> > 	BUG_ON(nfrozen != ntotal);
> 
> Heh, try to put a kthread into the cgroup and freeze it. :)

Ahh got it. So not related to the original issue. Just yet another issue
in the area.

Thanks
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
