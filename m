Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757767Ab1FVB36 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 21:29:58 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58865 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757582Ab1FVB3y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 21:29:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=TdInA1BV4ytjTHTKDZx9SQVdTUlZNXlQgwMfSv+HIE2+KUyRhVMdtRyrrUhejYfbJB
         4DnVSXP+II1b2Tz9OmkyWot1bY6zlKG7KgHtOumoePRe2ZR16ZkdnofW3aYeJMG7Dx9W
         dwuNq1FQB4nsLiLkoH8QXX52Ml2sRvXYl7DdU=
MIME-Version: 1.0
In-Reply-To: <BANLkTikq0XRkvkX6O5C2yKf6rRvMWciZpA@mail.gmail.com>
References: <m162nyn8jd.fsf@fess.ebiederm.org> <BANLkTikq0XRkvkX6O5C2yKf6rRvMWciZpA@mail.gmail.com>
From: Mike Snitzer <snitzer@gmail.com>
Date: Tue, 21 Jun 2011 21:29:33 -0400
Message-ID: <BANLkTikkHsd4kLnHdtS7D8QGBQyFuYhFBg@mail.gmail.com>
Subject: Re: [GIT PULL] nsfd fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        Linux Containers <containers@lists.osdl.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 9:25 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, Jun 21, 2011 at 3:07 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>>
>> When looking over my namespace file descriptor code I realized I goofed
>> in the implementation.  I missed the addition of d_set_d_op, and
>> painfully I badly placed the ptrace_may_read permission checks with the
>> result that the dcache could cache things and bypass the checks.
>>
>> The fixes are available at.
>> git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/linux-2.6-nsfd.git
>
> Why do you talk about nfsd fixes in both the repository name and in
> the subject line? This seems to have nothing to do with nfsd except in
> the crazy sense of somebody trying to export /proc with nfs.
>
> Not pulled due to extreme confusion and craziness.

I had to read it a couple times too: nSFd not nFSd.

As in Name Space File Descriptors.
