Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393Ab1EOOEm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 10:04:42 -0400
Received: from vps.jankratochvil.net ([46.28.109.124]:48870 "EHLO
	host1.jankratochvil.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753522Ab1EOOEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 10:04:41 -0400
X-Greylist: delayed 356 seconds by postgrey-1.27 at vger.kernel.org; Sun, 15 May 2011 10:04:41 EDT
Date: Sun, 15 May 2011 15:55:27 +0200
From: Jan Kratochvil <jan.kratochvil@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Tejun Heo <tj@kernel.org>, oleg@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu
Subject: ptrace-testsuite status  [Re: [PATCHSET ptrace] ptrace: implement
 PTRACE_SEIZE/INTERRUPT and group stop notification]
Message-ID: <20110515135527.GA31855@host1.jankratochvil.net>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
 <201105090027.41534.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105090027.41534.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 09 May 2011 00:27:41 +0200, Denys Vlasenko wrote:
> I don't know the status of ptrace test suite
> after I stopped working on strace (did the suite bit rot, or is it
> maintained and still relevant?). If it is still in use,
> I can adapt these tests and add them to it.

That is:
	http://sourceware.org/systemtap/wiki/utrace/tests
	cvs -d :pserver:anoncvs:anoncvs@sourceware.org:/cvs/systemtap co ptrace-tests 

The testsuite is actively in use but it has always been a regression testsuite
only and there are no known new regressions.  So there is no need for
testsuite updates now.

With new ptrace features sure their testcases would be nice to include there.
Despite there has never been an attempt to cover existing ptrace functionality
by the testcases.


Thanks,
Jan
