Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689Ab1FICFq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 22:05:46 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:43691 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab1FICFn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 22:05:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cUMiv2zJSbZvP4coJadf0ZsKETHrMzOQHe+vEPCl6pZ4YUCODY6z0TBlQ3Qw4h1M+0
         pe8hhZt7BaXt7U6q6mUQHm2PgjET3bKb4gWQ/XmPiXzNgzrjSl3CAdKdgNENVDhPt6iQ
         WV2fg1HYUHHd5cp2x4LN/hdCdDHmYo9iMUJFE=
MIME-Version: 1.0
In-Reply-To: <4DEFC43B.1080802@oracle.com>
References: <BANLkTimyBGfg4+ovGsiGqpCz345qVmU_7A@mail.gmail.com>
	<4DEFC43B.1080802@oracle.com>
Date: Thu, 9 Jun 2011 10:05:42 +0800
Message-ID: <BANLkTi=4=YkZezxkFh80JAwjH16Fu8PFXA@mail.gmail.com>
Subject: Re: LVM vs. Ext4 snapshots (was: [PATCH v1 00/30] Ext4 snapshots)
From: Yongqiang Yang <xiaoqiangnk@gmail.com>
To: Sunil Mushran <sunil.mushran@oracle.com>
Cc: "Amir G." <amir73il@users.sourceforge.net>,
        Mike Snitzer <snitzer@redhat.com>, Lukas Czerner <lczerner@redhat.com>,
        linux-ext4@vger.kernel.org, tytso@mit.edu,
        linux-kernel@vger.kernel.org, sandeen@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 9, 2011 at 2:49 AM, Sunil Mushran <sunil.mushran@oracle.com> wrote:
> On 06/08/2011 11:26 AM, Amir G. wrote:
>>
>> 2. Data blocks are never copied
>> The move-on-write technique is used to re-allocate data blocks on rewrite
>> instead of copying them.
>> This is not something that can be done when the snapshot is stored on
>> external storage, but it can done when the snapshot file lives in the fs.
>
> But does that not lead to fragmentation. And if I am understanding this,
> the fragmentation will not resolve after dropping the snapshot. So while
> you do save the overhead on write, you make the user pay on all future
> reads (that need to hit the disk).
Hi Sunil,

I am undertaking a project which aims to reduce fragmentation when the
file is rewritten.  When the snapshot is deleted, fragmentation
introduced by snapshot will be removed once the file is rewritten.  If
it is necessary, I think defragmentation can be done when the file is
read.

But it is not ready yet.  So it is not a part of the code which are
going to be merged.

Does I answer your question?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Best Wishes
Yongqiang Yang
