Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311Ab1EXSoj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 14:44:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48396 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755784Ab1EXSoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 14:44:38 -0400
MIME-Version: 1.0
In-Reply-To: <4DDBF40E.7020003@fusionio.com>
References: <4DDBF40E.7020003@fusionio.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 24 May 2011 11:37:08 -0700
Message-ID: <BANLkTi=sYVpvEwShbhC65qfaA0Jt3rEjsQ@mail.gmail.com>
Subject: Re: [GIT PULL] Start of removal of legacy parallel interfaces for 3.0
To: Jens Axboe <jaxboe@fusionio.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Chris Mason <chris.mason@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 11:08 AM, Jens Axboe <jaxboe@fusionio.com> wrote:
>
> With the 3.0 kernel approaching, now is a great time to get rid of some
> legacy bagage. And what better part to start with than the old IDE code.
> Parallel interfaces are so 1990's, we can't be seen with those on a
> fancy new kernel version.

No.

Guys. Really.

Any version numbering change is *not* an excuse to drop any old stuff,
or do anything new and exciting.

If the IDE maintainer eventually decides that there really are zero
users, that's a different thing, and will be independent of any
version number change. Dropping truly dead code is always welcome,
regardless of anything else. But it needs to be truly dead, not
"wouldn't it be nice if we didn't carry this any more".

                Linus
