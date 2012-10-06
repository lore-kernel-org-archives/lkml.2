Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150Ab2JFSTW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 14:19:22 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35385 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab2JFSTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 14:19:21 -0400
Message-ID: <1349547551.12699.45.camel@kjgkr>
Subject: Re: [PATCH 02/16] f2fs: add on-disk layout
From: Jaegeuk Kim <jaegeuk.kim@gmail.com>
To: Boaz Harrosh <openosd@gmail.com>
Cc: Dan Luedtke <mail@danrl.de>,
        =?euc-kr?Q?=B1=E8=C0=E7=B1=D8?= <jaegeuk.kim@samsung.com>,
        viro@zeniv.linux.org.uk, "'Theodore Ts'o'" <tytso@mit.edu>,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
Date: Sun, 07 Oct 2012 03:19:11 +0900
In-Reply-To: <506F4C90.1010003@gmail.com>
References: <000901cda2f0$7d773eb0$7865bc10$%kim@samsung.com>
	 <1349459677.22620.4.camel@tunafish> <506F4C90.1010003@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-10-05 (금), 14:09 -0700, Boaz Harrosh:
> On 10/05/2012 10:54 AM, Dan Luedtke wrote:
> > On Fri, 2012-10-05 at 20:56 +0900, 김재극 wrote:
> >> +	__le32 i_atime;			/* Access time */
> >> +	__le32 i_ctime;			/* inode Change time */
> >> +	__le32 i_mtime;			/* Modification time */
> >> +	__le32 i_btime;			/* file creation time*/
> > 
> > It's probably to late, but have you considered using 64 bit timestamps?
> > In LanyFS we use 64 bit and I'm very interested in reasoning for 32 bit
> > timestamps.
> > 
> 
> Yes and please don't make them millisecond resolution. This is a real headache.
> From the like of make to NFS to reboot/corruption recovery... the list is endless
> 
> Please make it nanoseconds resolution.
> 

Ok, I'll take a look at this.
Thanks,

> > Regards
> > 
> > Dan
> > 
> 
> Thanks
> Boaz
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Jaegeuk Kim
Samsung

