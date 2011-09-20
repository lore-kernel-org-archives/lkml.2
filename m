Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003Ab1ITFYq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 01:24:46 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54943 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab1ITFYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 01:24:44 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <4E77827C.3030202@redhat.com>
References: <CAKgNAkhZSb0UfZz7N+gKRQD0r7gnC_3-VCB_ORio8ojczbCDvQ@mail.gmail.com>
 <4E77827C.3030202@redhat.com>
From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Tue, 20 Sep 2011 07:24:24 +0200
Message-ID: <CAKgNAki0CtE6a_JLjPUsyozP2cfy_x8MSSYfhu5gMEeRE6Zaww@mail.gmail.com>
Subject: Re: Man page doc for SEEK_DATA/SEEK_HOLE
To: Eric Blake <eblake@redhat.com>
Cc: Josef Bacik <josef@redhat.com>, linux-man@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Eric

On Mon, Sep 19, 2011 at 7:57 PM, Eric Blake <eblake@redhat.com> wrote:
> On 09/18/2011 01:07 AM, Michael Kerrisk wrote:
>>
>> +
>> +.BR SEEK_DATA
>> +and
>> +.BR SEEK_HOLE
>> +are nonstandard extensions also present in Solaris.
>
> Looks good to me, but you may also want to link to the proposed wording for
> mandating SEEK_HOLE/SEEK_DATA in the eventual POSIX Issue 8 (POSIX 2008 is
> Issue 7):
> http://austingroupbugs.net/view.php?id=415
>
> Also, it seems a shame that the kernel can fail with EINVAL instead of
> properly emulating SEEK_HOLE and SEEK_DATA even on file systems with no
> underlying support for reporting holes.

Thanks for catching that. I've added that point.

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
