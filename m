Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757931Ab0JWQ0v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 12:26:51 -0400
Received: from mail.wdtv.com ([66.118.69.84]:34018 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756042Ab0JWQ0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 12:26:50 -0400
From: Gene Heskett <gene.heskett@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.36, make oldconfig broken
Date: Sat, 23 Oct 2010 12:26:45 -0400
User-Agent: KMail/1.13.5 (Linux/2.6.36; KDE/4.5.2; i686; ; )
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org
References: <201010221229.36996.gene.heskett@gmail.com> <201010221608.36754.gene.heskett@gmail.com> <20101023134102.GA7893@elte.hu>
In-Reply-To: <20101023134102.GA7893@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201010231226.45446.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, October 23, 2010, Ingo Molnar wrote:
>hi Gene,
>
>* Gene Heskett <gene.heskett@gmail.com> wrote:
>> > Please send your 2.6.35.7 .config file so that we can generate & see
>> > the changes.
>> 
>> Attached Randy, & many thanks.
>> 
>> Just for S&G I overwrote the generated .config in the 2.6.36 tree with
>> these files, and ran a make xconfig, which bitched about line 3109,
>> and which I don't recall ever playing with, "RAR_REGISTER" IIRC, so I
>> saved it without any other changes and built/installed & booted from
>> that now.
>
>In case it's useful: i take old .config's and put them into new kernels
>all the time, and i very much depend on configured drivers and options
>not going away suddenly. I know lots of other developers depend on that
>as well.
>
>In the hundreds or so cases i've done this manually in the past few years
>i only remember less than 5 cases where this didnt work in an 'as
>expected' way.
>
>So this should really work for you. If it doesnt when going from 2.6.35
>to 2.6.36 then that's very likely a bug somewhere which we want to fix
>...
>
>Thanks,
>
>	Ingo

It was suggested elsewhere in this thread that I run memcheck the next time 
I reboot.  Maybe that will spit something out.  I'll post if it does or 
doesn't when I do.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Bride, n.:
	A woman with a fine prospect of happiness behind her.
		-- Ambrose Bierce, "The Devil's Dictionary"
