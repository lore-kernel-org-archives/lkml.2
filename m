Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757850Ab1FVBZz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 21:25:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59917 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757824Ab1FVBZy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 21:25:54 -0400
MIME-Version: 1.0
In-Reply-To: <m162nyn8jd.fsf@fess.ebiederm.org>
References: <m162nyn8jd.fsf@fess.ebiederm.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 21 Jun 2011 18:25:02 -0700
Message-ID: <BANLkTikq0XRkvkX6O5C2yKf6rRvMWciZpA@mail.gmail.com>
Subject: Re: [GIT PULL] nsfd fixes
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, Linux Containers <containers@lists.osdl.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 3:07 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
> When looking over my namespace file descriptor code I realized I goofed
> in the implementation.  I missed the addition of d_set_d_op, and
> painfully I badly placed the ptrace_may_read permission checks with the
> result that the dcache could cache things and bypass the checks.
>
> The fixes are available at.
> git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/linux-2.6-nsfd.git

Why do you talk about nfsd fixes in both the repository name and in
the subject line? This seems to have nothing to do with nfsd except in
the crazy sense of somebody trying to export /proc with nfs.

Not pulled due to extreme confusion and craziness.

                   Linus
