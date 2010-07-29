Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757682Ab0G2OzV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 10:55:21 -0400
Received: from DMZ-MAILSEC-SCANNER-8.MIT.EDU ([18.7.68.37]:60439 "EHLO
	dmz-mailsec-scanner-8.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754108Ab0G2OzU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 10:55:20 -0400
X-AuditID: 12074425-b7bfeae000000a0d-e5-4c519659745b
Subject: Re: 2.6.36/37 suggestion
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <AANLkTinv8Ktf6BeGCNo6RkAHmD3-Ey20vHF1ycy025uR@mail.gmail.com>
Date: Thu, 29 Jul 2010 10:55:16 -0400
Cc: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <A2FA724F-1215-4DFE-B3AA-738D144B12F4@mit.edu>
References: <AANLkTinv8Ktf6BeGCNo6RkAHmD3-Ey20vHF1ycy025uR@mail.gmail.com>
To: Oleksandr Natalenko <pfactum@gmail.com>
X-Mailer: Apple Mail (2.1081)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 29, 2010, at 10:25 AM, Oleksandr Natalenko wrote:

> In reply to Ted Tso
> (http://article.gmane.org/gmane.linux.kernel/1008643) I would like to
> suggest kernel developers (first of all, Linus) some kind of
> compromise. Let's prohibit accepting new features during 2.6.36 merge
> window and accept only bugfixes until bugzilla and regression lists
> are empty. For drivers subsystem you may create separate branch and
> accept all changes there, then merge them into 2.6.37.

Been there, tried that, it doesn't work.   What people keep forgetting is that most developers are volunteers, and/or paid employees of companies that are primarily interested in well, doing development.   So prohibiting new features doesn't help, because people will just keep coding them in their own branches, and then when when we do try to merge the new features, the resulting kernel becomes even more unstable.

We have done graphs of the list of regression fixes over time, and after three months or so, the number of fixes that come in slow dramatically.  So we could extend the waiting period by an extra month, say, and it might fix a few more bugs, but the result is that all of the various subsystem branches have even more development, which increases the instability during the next merge window.   So this is a definitely a case of diminishing returns, and given the current set of developers, that's really all that can be done with what we have.

Now, if someone wants to pay developers (the golden rule: he with the gold makes the rules) to work on nothing but trying to get accurate reproduction information from users, and then fixing the bugs for those users, then we can improve the number of bugs that get fixed.  Or, if users with bugs want to get much more involved with testing kernels earlier in the -rc cycle, where it is easier to do git bisections, and to work harder to help the developers find and fix the bugs, then great, we can solve the problem.   Or they can use a six-month-old kernel from one of the community distributions.  Or they can pay for support from an enterprise distribution.  The last two involve fewer features but hey, you just said you were willing to prohibit new features from entering mainline.   If you want to deny new features to yourself, you're free to use a community or enterprise kernel.  But trying to deny those new features to everybody else, including those who have no problems with the current system, does seem to be a bit arrogant, don't you think?

So users have plenty of options.   But trust me, trying to forbid new features in mainline is ultimately self-defeating.

-- Ted (who still has his Lenovo T400 laptop running 2.6.35-rc3, mainly because it works for him and he hasn't had time to upgrade it to something newer)


