Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757047Ab2JWNSF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 09:18:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28166 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753815Ab2JWNSC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 09:18:02 -0400
Date: Tue, 23 Oct 2012 09:17:46 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, James Morris <jmorris@namei.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>, cgroups@vger.kernel.org
Subject: Re: [PATCH 1/4] cgroup: fix invalid rcu dereference
Message-ID: <20121023131746.GB14085@redhat.com>
References: <20121022134536.172969567@napanee.usersys.redhat.com>
 <20121022134536.543579196@napanee.usersys.redhat.com>
 <508692A8.6090706@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <508692A8.6090706@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 02:50:48PM +0200, Jiri Slaby wrote:
> No, I'm *not* the author of the patch... Or at least I don't remember
> :P. Where did you take it from?

<1347615612-11450-1-git-send-email-jslaby@suse.cz> 
Date: Fri, 14 Sep 2012 11:40:12 +0200

you didn't include a "From:" on your email, so I assumed it was from
you. it was sent to akpm with others and linux-kernel in cc

-- 
Aristeu

