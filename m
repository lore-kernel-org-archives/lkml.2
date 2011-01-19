Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab1ASCIV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 21:08:21 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47599 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753423Ab1ASCIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 21:08:20 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTimajU0x1v6y3rH2+jr-bZ=tNLs1S_agXdGGAa3S@mail.gmail.com>
References: <AANLkTimajU0x1v6y3rH2+jr-bZ=tNLs1S_agXdGGAa3S@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 18 Jan 2011 18:07:55 -0800
Message-ID: <AANLkTimp0UcWi68N5Jv_hUww9PhGVgCzY0qYLETc8Dj_@mail.gmail.com>
Subject: Re: Linux 2.6.38-rc1
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 18, 2011 at 3:54 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> It's been two weeks, and the merge window for 2.6.38 is thus closed.

Oh, and it looks like mirroring from master.kernel.org is being very
slow, possibly at least partly because the conversion to
xv-compression seems to be going on (who knows - there's obviously a
script going over all the public files recompressing them from gz to
xz, but it may be some kind of dry-run and not final).

And I may also have managed to hit the weekly rsync "check
_everything_" window too. So rsync likely isn't just checking and
syncing new files, but checksumming every single file that gets
mirrored out and re-verifying it.

End result: it looks like git.kernel.org and the ftp mirrors are going
to take hours to update. So if you don't see 2.6.38-rc1 yet, and you
don't have an account on kernel.org and can fetch it directly from
master, don't worry. It will mirror out eventually, but it's going to
take some time.

Sit back, relax, and sip some foofy drink. It will all work out in the end.

              Linus
