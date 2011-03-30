Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433Ab1C3Mkm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 08:40:42 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:47496 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681Ab1C3Mkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 08:40:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=pNG8oGOrx3I2EflueVnHtJmJ92FjVBYxbKs3MWwNdGwhpKpKxDdowoM0q/D2Mdfzc1
         NmlsC+tmwnavwkmzcPaSAswNrlQf5c5knng1mClJJNdwIijFK9vkRaTlzup8jTBIZ5BV
         z72YTl5VUNIMh94wR93a6/aGhZVFv6JE7PjTw=
MIME-Version: 1.0
In-Reply-To: <1301488032.3283.42.camel@edumazet-laptop>
References: <9bde694e1003020554p7c8ff3c2o4ae7cb5d501d1ab9@mail.gmail.com>
	<AANLkTinnqtXf5DE+qxkTyZ9p9Mb8dXai6UxWP2HaHY3D@mail.gmail.com>
	<1300960540.32158.13.camel@e102109-lin.cambridge.arm.com>
	<AANLkTim139fpJsMJFLiyUYvFgGMz-Ljgd_yDrks-tqhE@mail.gmail.com>
	<1301395206.583.53.camel@e102109-lin.cambridge.arm.com>
	<AANLkTim-4v5Cbp6+wHoXjgKXoS0axk1cgQ5AHF_zot80@mail.gmail.com>
	<1301399454.583.66.camel@e102109-lin.cambridge.arm.com>
	<AANLkTin0_gT0E3=oGyfMwk+1quqonYBExeN9a3=v=Lob@mail.gmail.com>
	<AANLkTi=gMP6jQuQFovfsOX=7p-SSnwXoVLO_DVEpV63h@mail.gmail.com>
	<1301476505.29074.47.camel@e102109-lin.cambridge.arm.com>
	<AANLkTi=YB+nBG7BYuuU+rB9TC-BbWcJ6mVfkxq0iUype@mail.gmail.com>
	<AANLkTi=L0zqwQ869khH1efFUghGeJjoyTaBXs-O2icaM@mail.gmail.com>
	<AANLkTi=vcn5jHpk0O8XS9XJ8s5k-mCnzUwu70mFTx4=g@mail.gmail.com>
	<1301485085.29074.61.camel@e102109-lin.cambridge.arm.com>
	<AANLkTikXfVNkyFE2MpW9ZtfX2G=QKvT7kvEuDE-YE5xO@mail.gmail.com>
	<1301488032.3283.42.camel@edumazet-laptop>
Date: Wed, 30 Mar 2011 13:40:40 +0100
Message-ID: <AANLkTimvwZXJup9NhzAdWr1dO2p7=usLrsXXhyy7zrk4@mail.gmail.com>
Subject: Re: kmemleak for MIPS
From: Maxin John <maxin.john@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Daniel Baluta <dbaluta@ixiacom.com>,
        naveen yadav <yad.naveen@gmail.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> How much memory do you have exactly on this machine ?

debian-mips:~# cat /proc/meminfo
MemTotal:         255500 kB
MemFree:          214848 kB
Buffers:            3116 kB
Cached:            15960 kB
SwapCached:            0 kB
Active:            10332 kB
Inactive:          12512 kB
Active(anon):       3776 kB
Inactive(anon):     2500 kB
Active(file):       6556 kB
Inactive(file):    10012 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:        738952 kB
SwapFree:         738952 kB
Dirty:                 0 kB
Writeback:             0 kB
AnonPages:          3796 kB
Mapped:             3300 kB
Shmem:              2508 kB
Slab:              16940 kB
SReclaimable:       2884 kB
SUnreclaim:        14056 kB
KernelStack:         272 kB
PageTables:          312 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:      866700 kB
Committed_AS:      36916 kB
VmallocTotal:    1048372 kB
VmallocUsed:         220 kB
VmallocChunk:    1048140 kB

> If you care about losing 8192 bytes of memory, you could boot with
>
> "uhash_entries=256"

Thank you very much for your inputs. I will try booting with this option.

Best Regards,
Maxin
