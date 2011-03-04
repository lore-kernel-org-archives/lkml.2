Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759233Ab1CDIVZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 03:21:25 -0500
Received: from mx4-phx2.redhat.com ([209.132.183.25]:49414 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759046Ab1CDIVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 03:21:24 -0500
Date: Fri, 4 Mar 2011 03:21:00 -0500 (EST)
From: CAI Qian <caiqian@redhat.com>
To: Cyril Hrubis <chrubis@suse.cz>
Cc: subrata@linux.vnet.ibm.com, ltp-list@lists.sf.net, vapier@gentoo.org,
        linux-kernel@vger.kernel.org,
        Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>,
        akpm@linux-foundation.org, torvalds@linux-foundation.org
Message-ID: <190369924.284397.1299226860624.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <20110303142453.GA21064@saboteur.suse.cz>
Subject: Re: [LTP] [ANNOUNCE] The Linux Test Project has been released for
 FEBRUARY 2011.
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.71]
X-Mailer: Zimbra 6.0.9_GA_2686 (ZimbraWebClient - FF3.0 (Linux)/6.0.9_GA_2686)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Well, I don't see what would be gained by merging parts of the LTP into
> kernel tree. As I said before, this would probably lead to splitting of
> the forces (and not that we have a lot to split anyway). LTP already has
> directory called testcases/kernel/, LTP is in the git repository and we
> have a mailing list. All that is needed is people start noticing that
> we are here.
Then, the approach to merge parts of LTP to kernel is to say "Here we are,
please accept our best". On the other hand, I have noticed that there are
many developers tend to have test code in their kernel submit changelog
which isn't it better to make life easier for them to add those testing
code in a proper place in kernel which in-turn to benefit in a long run.

> I don't think that it's easy to say if some tests are testing
> kernel/userspace. Sometimes the line isn't that clear.
There are C code as in kernel coding style. Scripting code like Bash, Perl
better to re-written in C that in a long run when there are something like
thousands of tests to run that performance/scalabitlies/maintenence is going
to matter just like to write an OS.

> Well, requiring maintainers to sign-off your tests is kind of dull. That
> would probably block the tests from being accepted just because
> maintainers don't care too much/have different things to do.
The idea is to raise a bar to get the best out of it. If maintainers don't
care too much about the testing right now that is fine. There are many people
they do care. A particular subsystem maintainer and its tests maintainer
aren't necessary to be the same person because subsystem maintainer isn't
necessary to be the best one to find/acknowledge defeats for code he maintained.

> You can't easily prove that something is best ;).
The best will at lest be reviewed by eyes from the kernel community and
experts, and will be the one to be accepted by the community.

> Once again, LTP does exist so reference to LTP is not ambiguous. Yes,
> it's, for historical reasons, hosted on sourceforge rather than
> kernel.org. But there it is.
By accepted into the kernel, it certainly make it easier to reference
without dealing with two projects and trees.

CAI Qian
