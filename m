Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621Ab0J3GK3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 02:10:29 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:34874 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443Ab0J3GK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 02:10:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=B3tv7wiKTGwltE7m3YbbLZOnYgAa3QaOwC9W8QT5LU9haJmcaLRQr4vcLNABVRPsP4
         2ZGo3TbRIo8a9eJ1cNWscbM/q96aPB6v5JNun5yDwx5sHPDM2sl22RQl0DJFnnkxOxTc
         HfPMchw8v2rZ1dR2oJcTIudBBpyMc/OpHoc3M=
Message-ID: <4CCBB6CA.6050707@gmail.com>
Date: Sat, 30 Oct 2010 14:10:18 +0800
From: =?UTF-8?B?IlNpbmdhcG9yZSBDaXRpemVuIE1yLiBUZW8gRW4gTWluZyAoWmhhbmcgRQ==?=
	 =?UTF-8?B?bm1pbmcpIOW8oOaBqem4oyAi?= 
	<space.time.universe@gmail.com>
Reply-To: space.time.universe@gmail.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
        stable@kernel.org, lwn@lwn.net,
        "space.time.universe@gmail.com" <space.time.universe@gmail.com>,
        "teoenming@hotmail.com" <teoenming@hotmail.com>,
        zhang_enming@lavabit.com
Subject: Re: Linux 2.6.32.24
References: <20101001205709.GA11271@kroah.com>
In-Reply-To: <20101001205709.GA11271@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2010 04:57 AM, Greg KH wrote:
> I'm announcing the release of the 2.6.32.24 kernel.
>
> This is only needed if you run Xen, there was a typo that caused
> problems.  My fault, sorry.
>
> The updated 2.6.32.y git tree can be found at:
>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.32.y.git
> and can be browsed at the normal kernel.org git web browser:
>          http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.32.y.git;a=summary
>
> thanks,
>
> greg k-h
>
> ------------
>
>   Makefile             |    2 +-
>   drivers/xen/events.c |    2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
>
> Greg Kroah-Hartman (1):
>        Linux 2.6.32.24
>
> James Dingwall (1):
>        Xen: fix typo in previous patch
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>    

I am going to give Linux kernel 2.6.32.24 a try.

Thank you very much.

-- 
Yours sincerely,

Singapore Citizen Mr. Teo En Ming (Zhang Enming) 张恩鸣 Dip(Mechatronics) BEng(Hons)(Mechanical Engineering)
Singapore Identity Card No.: S78*6*2*H
Location: Bedok Reservoir Road, Singapore
ZIP: 470103
Mobile Phone (Starhub Pre-paid): +65-8369-2618
Windows Live Messenger: teoenming-at-hotmail.com
My Youtube videos: http://www.youtube.com/user/enmingteo
Alma Maters:
[1] Singapore Polytechnic (Graduated 1998)
[2] National University of Singapore (Graduated 2006)
My Open Letter (Plea for Medical Help/Assistance) to World Leaders (Updated 28 August 2010):-
http://lists.mcs.anl.gov/pipermail/mpich-discuss/2010-August/007811.html
http://mythtv.org/pipermail/mythtv-users/2010-August/295952.html
http://archives.gentoo.org/gentoo-user/msg_f6a341d9623fda17880159b137c07335.xml
Photograph of Singapore Citizen Mr. Teo En Ming (Zhang Enming) 张恩鸣 #1:
http://i.imgur.com/M1FNX.jpg
Photograph of Singapore Citizen Mr. Teo En Ming (Zhang Enming) 张恩鸣 #2:
http://i51.tinypic.com/11u9irm.jpg
Photograph of Singapore Citizen Mr. Teo En Ming (Zhang Enming) 张恩鸣 #3:
http://www.imagevimage.com/images/Singapore_Citizen_Mr._Teo_En_Ming_%28Zhang_Enming%29.jpg
Photograph of Singapore Citizen Mr. Teo En Ming (Zhang Enming) 张恩鸣 #4:
http://www.merrypic.com/files/o397beqo7qw8wky5rjno.jpg
Photograph of Singapore Citizen Mr. Teo En Ming (Zhang Enming) 张恩鸣 #5:
http://piczasso.com/i/yicuz.jpg
Photograph of Singapore Citizen Mr. Teo En Ming (Zhang Enming) 张恩鸣 #6:
http://www.freeimagehosting.net/uploads/1b553b21ae.jpg

