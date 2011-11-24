Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406Ab1KXVMc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 16:12:32 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60990 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754020Ab1KXVMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 16:12:30 -0500
MIME-Version: 1.0
In-Reply-To: <20111124152018.66ee4f15447837dd01443fdb@canb.auug.org.au>
References: <20111124152018.66ee4f15447837dd01443fdb@canb.auug.org.au>
Date: Thu, 24 Nov 2011 13:12:29 -0800
X-Google-Sender-Auth: lkTRxn4W1r1ypaprW0Ihq_x5NiE
Message-ID: <CAOS58YP146w66g2hyJSn10hWjtWmSjQBo36BaJ4ZibZcJAB0nw@mail.gmail.com>
Subject: Re: linux-next: manual merge of the cgroup tree with the pm tree
From: Tejun Heo <tj@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Hocko <mhocko@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Nov 23, 2011 at 8:20 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Today's linux-next merge of the cgroup tree got a conflict in
> kernel/cgroup_freezer.c between commit 6907483b4e80 ("freezer: make
> freezing indicate freeze condition in effect") from the pm tree and
> commit 41dfa07cedcc ("cgroup_freezer: fix freezing groups with stopped
> tasks") from the cgroup tree.
>
> I think that the latter is a superset of the former (but I may be wrong),
> so I used that.

We'll need to do freezing() || is_task_frozen_enough() there. I'll
update pm-freezer after I push cgroup fix upstream next week.

Thank you.

-- 
tejun
