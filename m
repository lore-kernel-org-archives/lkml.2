Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243Ab1KOAyv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 19:54:51 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61558 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859Ab1KOAyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 19:54:50 -0500
Date: Tue, 15 Nov 2011 01:54:45 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: paul@paulmenage.org, rjw@sisk.pl, lizf@cn.fujitsu.com,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, matthltc@us.ibm.com,
        akpm@linux-foundation.org, oleg@redhat.com,
        kamezawa.hiroyu@Jp.fujitsu.com
Subject: Re: [PATCH 10/10] cgroup: kill subsys->can_attach_task(),
 pre_attach() and attach_task()
Message-ID: <20111115005442.GL9446@somewhere>
References: <1320191193-8110-1-git-send-email-tj@kernel.org>
 <1320191193-8110-11-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320191193-8110-11-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 01, 2011 at 04:46:33PM -0700, Tejun Heo wrote:
> These three methods are no longer used.  Kill them.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Acked-by: Paul Menage <paul@paulmenage.org>
> Cc: Li Zefan <lizf@cn.fujitsu.com>

Reviewed-by: Frederic Weisbecker <fweisbec@gmail.com>

Thanks!
