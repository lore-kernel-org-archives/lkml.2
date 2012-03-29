Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934023Ab2C2VuM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 17:50:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11534 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933292Ab2C2VuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 17:50:06 -0400
Date: Thu, 29 Mar 2012 17:49:59 -0400
From: Dave Jones <davej@redhat.com>
To: "Ted Ts'o" <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: lockups shortly after booting in current git.
Message-ID: <20120329214959.GA20783@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Ted Ts'o <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Wu Fengguang <fengguang.wu@intel.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <CA+55aFxOcMt_mcr+ZYwc-SpKbROnh4Gn7jqrFY_SZcBy1Ev7Qw@mail.gmail.com>
 <20120329182632.GA6891@redhat.com>
 <CA+55aFx-nzGm1ZZD5bNxmPF2orkXc1_4nCE0jdtznz+AqhBx3A@mail.gmail.com>
 <20120329195354.GA11790@redhat.com>
 <CA+55aFxyutCDZhVa8HCu=hpn0454sfoM27Jwh2heCN0cqg5pjA@mail.gmail.com>
 <20120329202619.GA14001@redhat.com>
 <20120329203926.GA13970@thunk.org>
 <CA+55aFwJkN2BmZJmWfB6FU0TuVKfmh4um8pMKYVUk3aG7JkNwQ@mail.gmail.com>
 <20120329211244.GA18684@redhat.com>
 <20120329214510.GD13970@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120329214510.GD13970@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 02:45:10PM -0700, Ted Ts'o wrote:

 > > I'll try a build with just that reverted, given the bisect build is taking a while.

up 30 minutes with that reverted, no problems so far..

 > But actually, normally when it's a PageWriteback stall, usually you
 > get a soft lockup warning, assuming that was compiled into the system.
 > And I didn't see that in your trace, which is surprising given the
 > symptoms you described.  Was it perhaps not included in your log file
 > snippet?  Or was soft lockup detection not enabled?

Enabled, didn't trigger.

	Dave

