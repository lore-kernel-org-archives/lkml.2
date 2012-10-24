Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030229Ab2JXRh7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 13:37:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20937 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030208Ab2JXRh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 13:37:58 -0400
Date: Wed, 24 Oct 2012 13:37:29 -0400
From: Dave Jones <davej@redhat.com>
To: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 155/193] init: remove CONFIG_EXPERIMENTAL
Message-ID: <20121024173729.GA7274@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Serge Hallyn <serge.hallyn@canonical.com>,
	Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Frederic Weisbecker <fweisbec@gmail.com>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
 <1351022666-6960-156-git-send-email-keescook@chromium.org>
 <20121024134831.GB7217@sergelap>
 <CAGXu5jJZxY4k2Xpg=nuUn6p6V8NqYBPmvAt4Y35eogZfYWSM+g@mail.gmail.com>
 <20121024171723.GA7698@sergelap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121024171723.GA7698@sergelap>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 12:17:23PM -0500, Serge Hallyn wrote:

 > > Some patches remove "(EXPERIMENTAL)" from Kconfig titles when there was
 > > no "depends on EXPERIMENTAL". I've removed the cases of these where I
 > 
 > Hm, I was under the impression that taskstats are not quite trusted yet,
 > but I could be way out of date with that.

One would hope so given..

config KVM
        tristate "Kernel-based Virtual Machine (KVM) support"
        ...
        select TASKSTATS

I suspect every distro kernel out there supports TASKSTATS as a result of that.

	Dave

