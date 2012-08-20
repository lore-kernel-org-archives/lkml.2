Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204Ab2HTEVD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 00:21:03 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:59799 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815Ab2HTEVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 00:21:01 -0400
MIME-Version: 1.0
In-Reply-To: <20120818132524.GW23464@ZenIV.linux.org.uk>
References: <1345282899-7534-1-git-send-email-linkinjeon@gmail.com>
	<20120818132524.GW23464@ZenIV.linux.org.uk>
Date: Mon, 20 Aug 2012 13:21:00 +0900
Message-ID: <CAKYAXd-5tdajYgGGm=5y0D8fLNLXwJUmV0Vr8uAkj-xK97egOg@mail.gmail.com>
Subject: Re: [PATCH 0/4] fat: fix ESTALE errors
From: Namjae Jeon <linkinjeon@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/8/18, Al Viro <viro@zeniv.linux.org.uk>:
> On Sat, Aug 18, 2012 at 05:41:39AM -0400, Namjae Jeon wrote:
>> From: Namjae Jeon <namjae.jeon@samsung.com>
>>
>> This patch-set eliminates the client side ESTALE errors when
>> a FAT partition exported over NFS has its dentries evicted
>> from the cache.
>>
>> One of the reasons for this error is lack of permanent inode
>> numbers on FAT which makes it difficult to construct persistent
>> file handles.This can be overcome by using the on-disk location
>> of the directory entries (i_pos) as the inode number.
>
> The hell it can.  You've just made them unstable on rename(2).
Hello. Al.
I will check rename(2) case.
Thanks for reply.
>
