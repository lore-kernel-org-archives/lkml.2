Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab1DKMTa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 08:19:30 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:56148 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754058Ab1DKMT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 08:19:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=xypvw8Rtv4+LzXyM5fvw2Iur/M8EQez3s5TXRmLNaHPpotnysacgDIVm2FT6rV/oKl
         sXZZRaovvqC/7PK2GzxMR6Ip5XSliv01bbGP1jGhDUM7aoL6VZGjoLzB69clKeuAgYq/
         PkDq0or67to9ClJfP7ZAq1z3UwoC2/4uuA3G0=
MIME-Version: 1.0
In-Reply-To: <20110411040544.GB21395@dastard>
References: <1302444629-17043-1-git-send-email-wanlong.gao@gmail.com>
	<1302444629-17043-5-git-send-email-wanlong.gao@gmail.com>
	<20110411040544.GB21395@dastard>
Date: Mon, 11 Apr 2011 20:19:28 +0800
Message-ID: <BANLkTinSYce3r0LbzfGnBwjpJNa=ZR2gFg@mail.gmail.com>
Subject: Re: [PATCH 5/5] xfs:removed the unused variable
From: wanlong gao <wanlong.gao@gmail.com>
To: Dave Chinner <david@fromorbit.com>
Cc: broonie@opensource.wolfsonmicro.com, geert@linux-m68k.org,
        starvik@axis.com, jesper.nilsson@axis.com, sameo@linux.intel.com,
        ian@opensource.wolfsonmicro.com, dp@opensource.wolfsonmicro.com,
        lrg@slimlogic.co.uk, James.Bottomley@suse.de, aelder@sgi.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/11/11, Dave Chinner <david@fromorbit.com> wrote:
> On Sun, Apr 10, 2011 at 10:10:29PM +0800, wanlong.gao@gmail.com wrote:
>> From: Wanlong Gao <wanlong.gao@gmail.com>
>>
>> removed the unused variable "bdi" of xfs_buf.c .
>>
>> Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
>> ---
>>  fs/xfs/linux-2.6/xfs_buf.c |    2 --
>>  1 files changed, 0 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
>> index 5ea4020..a125b32 100644
>> --- a/fs/xfs/linux-2.6/xfs_buf.c
>> +++ b/fs/xfs/linux-2.6/xfs_buf.c
>> @@ -657,8 +657,6 @@ xfs_buf_readahead(
>>  	xfs_off_t		ioff,
>>  	size_t			isize)
>>  {
>> -	struct backing_dev_info *bdi;
>> -
>>  	if (bdi_read_congested(target->bt_bdi))
>>  		return;
>
> <sigh>
>
> Doesn't anyone look anymore to see if a problem has already been
> reported before or fixed in the maintainers tree?
>
> FYI, you're about the 5th person to send this same patch....
>
Sorry for the dupe, I'll look anymore next time .
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>
