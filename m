Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894Ab2LCTBQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 14:01:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6735 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048Ab2LCTBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 14:01:14 -0500
Date: Mon, 3 Dec 2012 14:01:04 -0500
From: Aristeu Rozanski <aris@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Serge Hallyn <serge.hallyn@canonical.com>,
        cgroups@vger.kernel.org
Subject: Re: [PATCH 4/5] device_cgroup: make may_access() stronger
Message-ID: <20121203190104.GC32112@redhat.com>
References: <20121127193501.255267751@napanee.usersys.redhat.com>
 <20121127193502.817704289@napanee.usersys.redhat.com>
 <20121203174414.GI19802@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121203174414.GI19802@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2012 at 09:44:14AM -0800, Tejun Heo wrote:
> I kinda dislike this.  This isn't a performanc critical path where we
> must try our best to shave off a few condition checks.  There's no
> reason to encode the test like this.  Please just spell the conditions
> out in code rather than trying to build a magic series of equality
> tests which somehow ends up spewing out the correct results.

sure, will do. but this is not "magic", that's just logic simplification.

-- 
Aristeu

