Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261Ab2LCVgq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 16:36:46 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:44242 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944Ab2LCVgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 16:36:44 -0500
Date: Mon, 3 Dec 2012 13:36:38 -0800
From: Tejun Heo <tj@kernel.org>
To: Aristeu Rozanski <aris@redhat.com>
Cc: linux-kernel@vger.kernel.org, Serge Hallyn <serge.hallyn@canonical.com>,
        cgroups@vger.kernel.org
Subject: Re: [PATCH 5/5] device_cgroup: propagate local changes down the
 hierarchy
Message-ID: <20121203213638.GK19802@htj.dyndns.org>
References: <20121127193501.255267751@napanee.usersys.redhat.com>
 <20121127193503.114004167@napanee.usersys.redhat.com>
 <20121203180145.GJ19802@htj.dyndns.org>
 <20121203191411.GE32112@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121203191411.GE32112@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Aristeu.

On Mon, Dec 03, 2012 at 02:14:12PM -0500, Aristeu Rozanski wrote:
> > Maybe I'm misunderstanding something but the behavior seems a bit
> > inconsistent.  So, you can't add an exception which isn't allowed by
> > your parent, right?  But, if your parent disallows an existing
> > exception, you get to keep it?  I think it would be more consistent to
> > go either
> > 
> > * Allow all settings but apply only as allowed by the parent.
> > 
> > * Deny settings disallowed by the parent.  If parent's config changes,
> >   delete configs which fall outside the new config.
> 
> I prefer this one, in fact that's what was happening before and you
> suggested to not remove local preferences when they're not valid
> anymore.

If I'm contradicting my past self, my apologies.  I'm a bit conflicted
about what to do myself.  So, you prefer to change configurations
downstream as the parent gets updated.  I think you're right.  Let's
go with that.

Thanks.

-- 
tejun
