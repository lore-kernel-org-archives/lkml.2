Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab1HBOyc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 10:54:32 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48655 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493Ab1HBOy1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 10:54:27 -0400
MIME-Version: 1.0
In-Reply-To: <20110802142708.GA2967@thunk.org>
References: <CAPweEDyUJZ8ggm0zhMquKNM6Kd-ejjUXrCMR3TnJngukSHAFkw@mail.gmail.com>
	<CAPweEDyW9aTKJzUrVdANjK5mG0DW9+R4GRCG5_oaaX8RTEezwg@mail.gmail.com>
	<CAPweEDxo1_KaHSmqjg6YJz688g0=wsb4n3fZ0YRiUK_NWt_Kww@mail.gmail.com>
	<20110802142708.GA2967@thunk.org>
Date: Tue, 2 Aug 2011 15:54:25 +0100
Message-ID: <CAPweEDxE=O7=uBPp2EMbdJ7LZ2afnB773hDsYk7R45ZOOZeVRA@mail.gmail.com>
Subject: Re: corrupted ext4 1000gb filesystem (2.6.32, debian stable)
From: Luke Kenneth Casson Leighton <luke.leighton@gmail.com>
To: "Ted Ts'o" <tytso@mit.edu>,
        Luke Kenneth Casson Leighton <luke.leighton@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 2, 2011 at 3:27 PM, Ted Ts'o <tytso@mit.edu> wrote:

> *However*, if you have a RAID1 setup where the data on the disks are
> consistent, this can be the cause of much mischief.  Depending on
> which disk you read from the mirror, you might get different results.
> Once that's the case, all bets with e2fsck are off.

 ok - that would explain why the problem has appeared to go away when
i reduced the RAID1 to a single drive.  i'm presently waiting for the
two 1.5Tb drives to sync up (estimated another 24 hrs)

> Finally, I strongly recommend that when you are doing this kind of
> repair work, that you save a copy of everything you do useing a
> program like "script".  A transcript of the e2fsck output can be
> critally useful.  Reviewing the transcript can also be useful in
> identifying mistakes that you might have made during the recovery
> process.

 ok i'll bear that in mind.

> Regards,
>
>                                                - Ted
>
> P.S.  Note that if you are running e2fsck, and you haven't mounted
> the disk yet, if you are seeing failures after a second run of e2fsck,
> then it obviously can be a failing in the ext4 kernel code.

 ok, thank you ted.  based on that, i'll keep doing reports (and make
sure i use typescript).

 l.
