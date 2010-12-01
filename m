Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859Ab0LAT4C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 14:56:02 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55865 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756840Ab0LAT4A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 14:56:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TTDMvXu/bTrbQizmwMmLYyK82HYfAiFnvYILbOiKpxnYjbZGVnn8mzYwSSZKicdo/8
         QjSBSx7tA6NXmNHRmSpYej1FKuXChKFHTBwLEFhcE/7gVLUiaqcH7jK3DcypvK7UpMSi
         C9yUhwEopupNhq1M/F+fjeSsk21plQY369TUc=
MIME-Version: 1.0
In-Reply-To: <20101201113841.46e92def.akpm@linux-foundation.org>
References: <1291216245-18574-1-git-send-email-virtuoso@slind.org>
	<1291216245-18574-2-git-send-email-virtuoso@slind.org>
	<20101201165418.GU5063@radis.liafa.jussieu.fr>
	<20101201113841.46e92def.akpm@linux-foundation.org>
Date: Thu, 2 Dec 2010 05:55:59 +1000
Message-ID: <AANLkTikYmVQ3A+DArFq+7z1MvhZDR6z+3-VdJpoRMV1K@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH 1/4] drm: fix headers to include linux/types.h
From: Dave Airlie <airlied@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Julien Cristau <jcristau@debian.org>,
        Alexander Shishkin <virtuoso@slind.org>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 2, 2010 at 5:38 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed, 1 Dec 2010 17:54:18 +0100
> Julien Cristau <jcristau@debian.org> wrote:
>
>> On Wed, Dec  1, 2010 at 17:10:42 +0200, Alexander Shishkin wrote:
>>
>> > For headers that get exported to userland and make use of u32 style
>> > type names, it is advised to include linux/types.h.
>> >
>> > This fixes 5 headers_check warnings.
>> >
>> How many times does this need to be NAKed?
>
> Until someone gets a clue and puts comments in there explaining this?

how about someone fixing the dumb scripts to understand that C header
includes aren't single level.

Like 10 people have posted this patch and not one has come back with a
fix for the app after I pointed it out, like really if people think
they can write C good enough to send kernel patches,
maybe they could put some more effort in and actually fix a real problem.

We should start hashing signed-off-by's so people can't get any glory from them.

Dave.
