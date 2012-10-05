Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964875Ab2JEVJk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 17:09:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38043 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964815Ab2JEVJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 17:09:39 -0400
Message-ID: <506F4C90.1010003@gmail.com>
Date: Fri, 05 Oct 2012 14:09:36 -0700
From: Boaz Harrosh <openosd@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Dan Luedtke <mail@danrl.de>
CC: =?UTF-8?B?6rmA7J6s6re5?= <jaegeuk.kim@samsung.com>,
        viro@zeniv.linux.org.uk, "'Theodore Ts'o'" <tytso@mit.edu>,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
Subject: Re: [PATCH 02/16] f2fs: add on-disk layout
References: <000901cda2f0$7d773eb0$7865bc10$%kim@samsung.com> <1349459677.22620.4.camel@tunafish>
In-Reply-To: <1349459677.22620.4.camel@tunafish>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2012 10:54 AM, Dan Luedtke wrote:
> On Fri, 2012-10-05 at 20:56 +0900, 김재극 wrote:
>> +	__le32 i_atime;			/* Access time */
>> +	__le32 i_ctime;			/* inode Change time */
>> +	__le32 i_mtime;			/* Modification time */
>> +	__le32 i_btime;			/* file creation time*/
> 
> It's probably to late, but have you considered using 64 bit timestamps?
> In LanyFS we use 64 bit and I'm very interested in reasoning for 32 bit
> timestamps.
> 

Yes and please don't make them millisecond resolution. This is a real headache.
>From the like of make to NFS to reboot/corruption recovery... the list is endless

Please make it nanoseconds resolution.

> Regards
> 
> Dan
> 

Thanks
Boaz
