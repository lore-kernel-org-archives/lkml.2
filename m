Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191Ab2CIPcv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 10:32:51 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54280 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295Ab2CIPcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 10:32:50 -0500
MIME-Version: 1.0
In-Reply-To: <20120309145406.GL4334@twin.jikos.cz>
References: <CADDYkjQHvmfhmsdt7K0O74DZK6BVqxPaWh_jEi8uJ_HBEz-QhQ@mail.gmail.com>
	<20120308155211.GF4334@twin.jikos.cz>
	<CADDYkjTG-q5+pFRFt9sGKq=cgL=ZgQaNZV=2ipBsSbuvxCa3jw@mail.gmail.com>
	<4F595D6D.6080809@cn.fujitsu.com>
	<20120309105537.GG4334@twin.jikos.cz>
	<CADDYkjRcRbxxPErdMBOs55-gNHZA0GfxcsWNrVbAuv37b3rtvw@mail.gmail.com>
	<20120309114010.GH4334@twin.jikos.cz>
	<CADDYkjQiMpPHLq4NTe5yo1iZfCgtwTgm+3ZDRUdMACpumsdFqw@mail.gmail.com>
	<CADDYkjRK3h_e3GPDQMpVwSwn6aQ5MwA1FoF1wFV05=LytK3chg@mail.gmail.com>
	<20120309145406.GL4334@twin.jikos.cz>
Date: Fri, 9 Mar 2012 16:32:48 +0100
Message-ID: <CADDYkjTTOoLSsp5_c3SsxfAmUH=qOeE_rtLT25dOY6f-3f7Eww@mail.gmail.com>
Subject: Re: kernel BUG at fs/btrfs/delayed-inode.c:1466!
From: Jacek Luczak <difrost.kernel@gmail.com>
To: dave@jikos.cz, Jacek Luczak <difrost.kernel@gmail.com>,
        Liu Bo <liubo2009@cn.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, josef@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/3/9 David Sterba <dave@jikos.cz>:
> On Fri, Mar 09, 2012 at 03:33:24PM +0100, Jacek Luczak wrote:
>> > Those two issues go inline. After a longer while of WARN_ON the BUG_ON
>> > hit again.
>>
>> One more observation. Host is running builds from CI system. After
>> BUG_ON pop up all builds take 50% more time to complete.
>
> After a BUG_ON the system is in an inconsistent state and will
> misbehave.
>
>> Also I see that current load average stall at value of 7 even if host
>> is completely idle.
>
> That's probably because some process is stuck in a D-state after the
> crash.
>

Now when I've tried to bring CI back I had to clean the broken builds
from BUG_ON run. The svn up fails:

open("/btrfs/project1/.svn/lock", O_WRONLY|O_CREAT|O_EXCL, 0666) = -1
ENOSPC (No space left on device)

-Jacek
