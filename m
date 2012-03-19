Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab2CSK0q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 06:26:46 -0400
Received: from mx2.parallels.com ([64.131.90.16]:50883 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754010Ab2CSK0p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 06:26:45 -0400
Message-ID: <4F67098C.4050902@parallels.com>
Date: Mon, 19 Mar 2012 14:25:16 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <lizf@cn.fujitsu.com>, <containers@lists.linux-foundation.org>,
        <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <fweisbec@gmail.com>, <rni@google.com>, <ctalbott@google.com>
Subject: Re: [PATCH 01/10] cgroup: move cgroup_clear_directory() call out
 of cgroup_populate_dir()
References: <1331940963-15756-1-git-send-email-tj@kernel.org> <1331940963-15756-2-git-send-email-tj@kernel.org>
In-Reply-To: <1331940963-15756-2-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2012 03:35 AM, Tejun Heo wrote:
> cgroup_populate_dir() currently clears all files and then repopulate
> the directory; however, the clearing part is only useful when it's
> called from cgroup_remount().  Relocate the invocation to
> cgroup_remount().
>
> This is to prepare for further cgroup file handling updates.
>
> Signed-off-by: Tejun Heo<tj@kernel.org>

Acked-by: Glauber Costa <glommer@parallels.com>

