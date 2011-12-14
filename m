Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606Ab1LNENC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 23:13:02 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:39306 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754145Ab1LNEM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 23:12:59 -0500
Date: Tue, 13 Dec 2011 23:12:51 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Hugh Dickins <hughd@google.com>
Cc: Allison Henderson <achender@linux.vnet.ibm.com>,
        Yongqiang Yang <xiaoqiangnk@gmail.com>,
        Curt Wohlgemuth <curtw@google.com>, Surbhi Palande <csurbhi@gmail.com>,
        Rafael Wysocki <rjw@sisk.pl>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>
Subject: Re: Bug with "fix partial page writes" [3.2-rc regression]
Message-ID: <20111214041251.GG6276@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, Hugh Dickins <hughd@google.com>,
	Allison Henderson <achender@linux.vnet.ibm.com>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Curt Wohlgemuth <curtw@google.com>,
	Surbhi Palande <csurbhi@gmail.com>, Rafael Wysocki <rjw@sisk.pl>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andy Whitcroft <apw@canonical.com>
References: <20111121165626.GD14568@thunk.org>
 <alpine.LSU.2.00.1111211331120.1879@sister.anvils>
 <alpine.LSU.2.00.1112051456580.3938@sister.anvils>
 <4EDD729E.2060402@linux.vnet.ibm.com>
 <alpine.LSU.2.00.1112060030220.1615@sister.anvils>
 <4EDE85F4.4020503@linux.vnet.ibm.com>
 <CAGBYx2YmYRw_p5KHJCYaQNsCpe5OVV7X2TpaK=OE7znCiE7oZA@mail.gmail.com>
 <4EDF9CAB.3050502@linux.vnet.ibm.com>
 <4EE046C7.9030902@linux.vnet.ibm.com>
 <alpine.LSU.2.00.1112080909300.22300@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1112080909300.22300@sister.anvils>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Hugh,

If you could do me a favor and run your "kernel compile torture test"
on the tree found on the "dev" branch of the git tree at:

git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git

... I'd really appreciate it.  This should have all of the patches
needed to address the problems you had been having, and it would be
great to get some additional testing before I push it to Linus.

I'm currently running a full xfstests run on this tree as we speak....

    	      	      	     	      	     - Ted
