Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887Ab2GYWGl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 18:06:41 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:49089 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062Ab2GYWGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 18:06:39 -0400
MIME-Version: 1.0
In-Reply-To: <20120725204350.GA20530@havoc.gtf.org>
References: <20120725203551.GA19762@havoc.gtf.org> <20120725204350.GA20530@havoc.gtf.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 25 Jul 2012 15:06:17 -0700
X-Google-Sender-Auth: 4hgThN2tnmZMThhmF3YG5_ZUwBo
Message-ID: <CA+55aFwCCctcmryQJMCT_3TDr60CYBQKu9HMyxOgS8482+w5Xw@mail.gmail.com>
Subject: Re: [git patches] libata updates
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 1:43 PM, Jeff Garzik <jeff@garzik.org> wrote:
> On Wed, Jul 25, 2012 at 04:35:51PM -0400, Jeff Garzik wrote:
>> Please pull 641589bff714f39b33ef1d7f02eaa009f2993b64 from
>> git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git tags/upstream
>>
>
> Oh, I forgot to point out the merge commit, making my HEAD more recent
> than might be expected.  There was a merge conflict and an API change
> that needed to be dealt with, in order for your pull to be correct.

So I'd *much* rather see an explanation of what the conflict is when
you ask me to pull, and let me handle it, rather than you pre-merging
things for me. I *want* to see conflicts between subsystems.
Seriously.

                   Linus
