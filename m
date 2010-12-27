Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411Ab0L0Jzf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 04:55:35 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:53452 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965Ab0L0Jzc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 04:55:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=reiys6rHrorUCeekuafbx7UE/snmhgBeFBd+tnR5WVx5DUt/Xa8fJBbtg/CIw0f9r1
         1DjkBZiMTb3M8R5EPXovW2TmKdxglWey/p5Si0nlhl02S9KXNabcYJ02MNyTtPbOruPH
         t0M9B7+LMUGdmMovMPlVfcLf9Y0g2i9ORx66c=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20101227201155.ee8cd1ab.sfr@canb.auug.org.au>
References: <20101227170451.a9a9f873.sfr@canb.auug.org.au>
	<AANLkTikbiART+SX_JwM=pcAg0NJffVgX1oU=aO42dmbC@mail.gmail.com>
	<20101227201155.ee8cd1ab.sfr@canb.auug.org.au>
Date: Mon, 27 Dec 2010 10:55:30 +0100
Message-ID: <AANLkTinVO8Mf4LnSj5fbtpHXHtwc8Wf306XEDgaqH437@mail.gmail.com>
Subject: Re: linux-next: Tree for December 27
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 27, 2010 at 10:11 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi,
>
> On Mon, 27 Dec 2010 09:04:06 +0100 Sedat Dilek <sedat.dilek@googlemail.com> wrote:
>>
>> Can you try to upload/push via IPADDR?
>
> I can only upload to master.kernel.org, the rest is done by the mirroring
> software.  I have no access to any of the other kernel.org machines.
>

I was wondering about still "slow mirrors" as also checking out before
Xmas was very slow.
Now, seeing from an end-users point, the checking-out is just fine.
I tried to clone
"$GIT_MIRROR/pub/scm/linux/kernel/git/npiggin/linux-npiggin.git" where
GIT_MIRROR was:

1. git://130.239.17.7
2. git://199.6.1.166
3. git//git.kernel.org
4. git//git.eu.kernel.org

All checkouts had around 680-690KiB/s.

[...]

>> Can you please upload the patch-diff to
>> <http://www.kernel.org/pub/linux/kernel/v2.6/next/>?
>
> If you mean for next-20101223, then there wasn't one.  I ran out of time
> and just threw away what I had done.
>
> If you mean generally, then (see above) it depends on the mirroring
> software.
>

Dunno what you mean with "mirroring software", but I am primarily
interested in the patch-v2.6.37-rc7-next-20101227 than in an updated
linux-next GIT repo.
IMHO, it should be possible to generate this patch from your local GIT
repo and upload the diff-patch to whereever is fast and accessible by
you.
My kernel-build-system has as base a vanilla upstream (here:
2.6.37-rc7) against which I apply an individual patch-series incl. the
linux-next diff-patch.
Hope this helps a bit to understand what I was talking about.

- Sedat -
