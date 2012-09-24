Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926Ab2IXDmm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 23:42:42 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:47849 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754800Ab2IXDml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 23:42:41 -0400
MIME-Version: 1.0
In-Reply-To: <87pq5e8fgb.fsf@devron.myhome.or.jp>
References: <1347798130-2626-1-git-send-email-linkinjeon@gmail.com>
	<87pq5e8fgb.fsf@devron.myhome.or.jp>
Date: Mon, 24 Sep 2012 12:42:39 +0900
Message-ID: <CAKYAXd_sowSZcsOYSLc4MkN16oehupq8BtJ0aNRSdngaABHm7g@mail.gmail.com>
Subject: Re: [PATCH v3 1/5] fat: modify nfs mount option
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: akpm@linux-foundation.org, bfields@fieldses.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/9/22, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>> +		case Opt_nfs_full:
>> +			opts->nfs = FAT_NFS_FULL;
>> +			break;
>> +		case Opt_nfs_limited:
>> +			opts->nfs = FAT_NFS_LIMITED;
>> +			sb->s_flags |= MS_RDONLY;
>> +			break;
>
Hi. OGAWA.
> Check opt->nfs at end of parse_option(). Otherwise, multiple nfs options
> would confuse it.
Yes, I will check it.
>
> E.g.
>
> 	mount -o nfs=limited_stable,nfs=full_unstable
>
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
