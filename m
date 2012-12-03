Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751Ab2LCR32 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 12:29:28 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35645 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755641Ab2LCR3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 12:29:25 -0500
Date: Mon, 3 Dec 2012 09:29:19 -0800
From: Tejun Heo <tj@kernel.org>
To: Aristeu Rozanski <aris@redhat.com>
Cc: linux-kernel@vger.kernel.org, Serge Hallyn <serge.hallyn@canonical.com>,
        cgroups@vger.kernel.org
Subject: Re: [PATCH 1/5] device_cgroup: fix locking in devcgroup_destroy()
Message-ID: <20121203172919.GG19802@htj.dyndns.org>
References: <20121127193501.255267751@napanee.usersys.redhat.com>
 <20121127193501.728193744@napanee.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121127193501.728193744@napanee.usersys.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 02:35:02PM -0500, Aristeu Rozanski wrote:
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Serge Hallyn <serge.hallyn@canonical.com>
> Signed-off-by: Aristeu Rozanski <aris@redhat.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
