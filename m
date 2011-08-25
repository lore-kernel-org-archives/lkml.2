Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214Ab1HYJpH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 05:45:07 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58580 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320Ab1HYJpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 05:45:04 -0400
Date: Thu, 25 Aug 2011 11:44:59 +0200
From: Tejun Heo <tj@kernel.org>
To: Paul Menage <paul@paulmenage.org>
Cc: rjw@sisk.pl, lizf@cn.fujitsu.com, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: [PATCH 2/6] cgroup: improve old cgroup handling in
 cgroup_attach_proc()
Message-ID: <20110825094459.GH3286@htj.dyndns.org>
References: <1314138000-2049-1-git-send-email-tj@kernel.org>
 <1314138000-2049-3-git-send-email-tj@kernel.org>
 <CALdu-PBr-tu1qzScvncr-N4EpPaQ7sTdHf28GhEv_MZLbo1eSg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALdu-PBr-tu1qzScvncr-N4EpPaQ7sTdHf28GhEv_MZLbo1eSg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 02:42:46AM -0700, Paul Menage wrote:
> > +       int retval, i, group_size, nr_todo;
> 
> I'd be inclined to call "nr_todo" something like "nr_migrating_tasks"
> for clarity.

Will update.

Thanks.

-- 
tejun
