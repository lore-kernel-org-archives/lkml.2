Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934447Ab1CYCcm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 22:32:42 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:36354 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934394Ab1CYCcg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 22:32:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=IhNvXyMW94KNyyi5KvelRsN15vjXvZegDPjUAMt2RVKmMgI+S0O07Aw74coykUOKV2
         P1AX5mkTbpq/8C+uTZmv5lefqLqlO9lYLzSqbUoLLECiTGcyNHWjPbZrCCTw83LJDH02
         3nX6IoOwGeeLOBsHTz0Qv61IbhgDYB/rBcah4=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20110324224047.GN2356@decadent.org.uk>
References: <1300845590-14184-1-git-send-email-valerie.aurora@gmail.com>
	<AANLkTinnRz2PPc3XqgCK72S9+fqTK0QCUOLkK98S5j_Q@mail.gmail.com>
	<20110324224047.GN2356@decadent.org.uk>
Date: Fri, 25 Mar 2011 03:32:35 +0100
Message-ID: <AANLkTi=2axu52Mbj+N+qUL+1vUJAU2-maL3w3dV740Et@mail.gmail.com>
Subject: Re: [PATCH 00/74] Union mounts version something or other
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Valerie Aurora <valerie.aurora@gmail.com>, linux-fsdevel@vger.kernel.org,
        viro@zeniv.linux.org.uk, LKML <linux-kernel@vger.kernel.org>,
        Felix Fietkau <nbd@openwrt.org>, hch@lst.de,
        Miklos Szeredi <miklos@szeredi.hu>,
        "J. R. Okajima" <hooanon05@yahoo.co.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 11:40 PM, Ben Hutchings <ben@decadent.org.uk> wrote:
> On Wed, Mar 23, 2011 at 09:38:39AM +0100, Sedat Dilek wrote:
> [...]
>> Whuzzz up with AUFS?
>> Even there where massive changes to VFS and FS in 2.6.38+, there is an
>> adapted kernel patch around (for example see Debian's 2.6.38 linux-2.6
>> packages in experimental branch).
>
> Do not cite the Debian kernel team as supporting aufs.  It is included
> only because Debian Live needs some kind of union filesystem, and only
> until that appears in-tree.
>

Debian is using AUFS - that is a fact!
That is exactly what I mean... as there is no *official* (and working!
and really used) union-filesystem from kernel-side.
Diverse distributions (and especially the embedded area) use AUFS (as
overlay) and SquashFS (for compression) as an *unofficial* working
solution for years. including Debian.
SquashsFS and hopefully SquashFS-XZ is in the kernel, but not AUFS.
So, I am interested in (a new discussion and) re-thinking what is the
number #1 choice in that area.
BTW, in the meantime Ric Wheeler asked for a comparison between
Union-mounts and OverlayFS  [1].
Let's see and read.

>> From my POV OverlayFS is the new star at the skyline and should be
>> promoted as 1st choice, now.
> [...]
>
> This thread is for technical review, not marketing.
>

My POV is clear - I already gave some technical arguments contra union-mounts.
An official and working(!) solution is needed and "promoted" from the
big five in Linux kernel (filesystem) development.
A decision what is the (next and new preferred?) standard
union-filesystem in the kernel-world.
Now, there is a new problem for union-mounts as one of its main
maintainer stopped working on it.
Even OverlayFS is young, it is already used as a working(!) solution in OpenWRT.
People do not need and want a never-ending "technical preview" for
years, they need and want a working(!) solution, that is/was mostly
AUFS chosen *unofficially* (and remember rejected into mainline).
Personally, I did not see/read union-mounts used by any distro or in
the embedded world.

- Sedat -

[1] http://www.spinics.net/lists/linux-fsdevel/msg43345.html
