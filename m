Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273Ab2ENCwq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 22:52:46 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:59957 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922Ab2ENCwo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 22:52:44 -0400
MIME-Version: 1.0
In-Reply-To: <20120514095454.39dd3f95eead6d94ea4f554d@canb.auug.org.au>
References: <20120514095454.39dd3f95eead6d94ea4f554d@canb.auug.org.au>
Date: Sun, 13 May 2012 21:52:44 -0500
Message-ID: <CAH2r5mvt2ApHfbT8MbZtdNGnBD+SETY-e8CqmGNYLE-6C-=0Ew@mail.gmail.com>
Subject: Re: linux-next: failed to fetch the cifs tree
From: Steve French <smfrench@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-cifs@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Should be ok now.

I had to rebuild the for-next branch of cifs-2.6.git due to a problem
caused by a previous "git push --force" (I had already fixed the
master branch of cifs-2.6.git but had not fixed up the for-next
branch).  It is now recreated and some patches from Jeff and Pavel
remerged.

On Sun, May 13, 2012 at 6:54 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> Trying to fetch the cifs tree gets this error:
>
> fatal: Couldn't find remote ref refs/heads/for-next
>
> and checking via "git ls-remote" shows that the remote tree has only a
> "master" branch that is set to v3.4-rc7.   Something got lost along the
> way ...
>
> I will use the cifs tree from next-20120511 for today.
>
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au



-- 
Thanks,

Steve
