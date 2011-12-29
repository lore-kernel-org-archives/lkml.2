Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751563Ab1L2Gig (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 01:38:36 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59559 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885Ab1L2Gid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 01:38:33 -0500
MIME-Version: 1.0
In-Reply-To: <20111228125631.GB9894@nb24cis>
References: <CAOh0hwO03GJ2ApNW6GV5fJKJ4S+hTv3An7vLTO4qaL4U9grdJg@mail.gmail.com>
	<CAFLxGvyWWCAfk-fCCc3NhCE=KbE-Y7ivO5gynSbCubxPC8d-uw@mail.gmail.com>
	<CAOh0hwOpzXRp9k70qK6rWURE5414c0=A2ALEBtL=77xxDW9hiw@mail.gmail.com>
	<20211.28256.111279.27933@quad.stoffel.home>
	<CAOh0hwPeveaEaNv_mjNVLM36JSbObX4n5y1jC_Yp5MwdBA0Sxw@mail.gmail.com>
	<20212.37458.896503.997111@quad.stoffel.home>
	<CAOh0hwOO3iMmP5kKUvN6cexHU0dUPra1qD-_UCP_4_qSVx7Euw@mail.gmail.com>
	<20111228125631.GB9894@nb24cis>
Date: Thu, 29 Dec 2011 12:08:33 +0530
Message-ID: <CAOh0hwP=Pq0Gbd002QGVvULNj60o2RPR3sZz94RVZvM2pstVzQ@mail.gmail.com>
Subject: Re: Intercepting system calls
From: Gaurav Saxena <grvsaxena419@gmail.com>
To: Wojciech Zygmunt Porczyk <wojciech@porczyk.eu>
Cc: John Stoffel <john@stoffel.org>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Wojciech, Thanks for your reply.

On 12/28/11, Wojciech Zygmunt Porczyk <wojciech@porczyk.eu> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On Fri, Dec 23, 2011 at 10:33:45PM +0530, Gaurav Saxena wrote:
>> I am trying to write an application which would create a backup for
>> the system so that it could be restored as it is. For example I create
>> a backup using my application. I just do nothing at time of backup so
>> it would be fast. Now whenever I see any deletion I would save that
>> file so that I could restore it.
>
> You almost certainly wan't to research LVM(-like) snapshots. They are
> operating in block layer, so you can restore fs "as it was", with COW
> feature they do "nothing" at creation and just save overwritten data
> somewhere else.
Yes I understand what I want to implement is done in LVM snapshots.
But I want to implement this functionality using a different approach.
As LVM are filesystem dependent and cannot work without repartitioning
of the system. Also they make system slow after many snapshots are
created.
>
> See: lvcreate(8), xfs_freeze(8). Maybe btrfs(8) ("btrfs subvolume
> snapshot") but btrfs is not really production-ready, so get lvm2+xfs.
>
> - --
> regards
> WZJP
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v2.0.18 (GNU/Linux)
>
> iEYEARECAAYFAk77Ef8ACgkQDgvLOJe6jMmQuACfassIV+vXCTmvMCTUqa81wgFf
> lBcAoLwYdPf59FEJ7sl/lzyHLLo4pG2r
> =Zt0G
> -----END PGP SIGNATURE-----
>


-- 
Thanks and Regards ,
Gaurav
