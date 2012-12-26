Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab2LZJMJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 04:12:09 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:59673 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984Ab2LZJMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 04:12:05 -0500
MIME-Version: 1.0
In-Reply-To: <1356509836.28255.4.camel@joe-AO722>
References: <1356145725-19940-1-git-send-email-linkinjeon@gmail.com>
	<1356486933.16178.144.camel@kjgkr>
	<CAKYAXd_-c4Mh0hQHBiNDVOrWmq=TVXEuoaWd1hzrA70t9p6=ag@mail.gmail.com>
	<1356488089.28255.1.camel@joe-AO722>
	<CAKYAXd_1VjQAVyGkvLKqy1ceE8rKCz1cRuoWg+RgSEF-M_OFEA@mail.gmail.com>
	<1356509836.28255.4.camel@joe-AO722>
Date: Wed, 26 Dec 2012 18:12:03 +0900
Message-ID: <CAKYAXd_ujxCEsLgHRu+xjZgf8yeP+CYanDv6feWJDCM89t1X8Q@mail.gmail.com>
Subject: Re: [PATCH 1/5] f2fs: Introduce some information prints in the mount path
From: Namjae Jeon <linkinjeon@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: jaegeuk.kim@samsung.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/12/26, Joe Perches <joe@perches.com>:
> On Wed, 2012-12-26 at 13:22 +0900, Namjae Jeon wrote:
>> 2012/12/26, Joe Perches <joe@perches.com>:
>> > On Wed, 2012-12-26 at 11:10 +0900, Namjae Jeon wrote:
>> >> 2012/12/26, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
>> >> > Could you make them follow the file system convention?
>> >> > Something like "F2FS: blah blah~".
>> >> Yes,  I agree.
>> >> > Otherwise, how about adding a debugging function to express the
>> >> > prefix?
>> >> Okay, I will send you the patches included your suggestion.
>> > Add
>> > #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>> > before any #include
>> Hi Joe.
>
> Hello Namjae
>
>> I think we can have debugging message function for f2fs similar to
>> ext4/fat like fat_msg, ext4_msg.
>> It is one time change but in the future it will allow more convenience
>> to use that way.
>> What is your opinion ?
>>
>> Or is that we have to to use pr_xxx function for error print instead
>> of own print debug function ?
>
> Sure, make your own f2fs_dbg function/macro when
> and if you have an object you want to pass along
> with the format and args
>
> something like:
>
> fs2fs_printk(struct fs2fs_handle *f2h, const char *fmt, ...)
>
> Otherwise, just use pr_debug/pr_<level>(fmt, ...)
Okay, Thanks for reply!

>
> cheers, Joe
>
>
