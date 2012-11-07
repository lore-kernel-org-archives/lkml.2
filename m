Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab2KGV6z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 16:58:55 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:34523 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377Ab2KGV6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 16:58:54 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1211072147040.27271@pobox.suse.cz>
References: <alpine.LNX.2.00.1210262112370.19184@pobox.suse.cz>
 <CA+1xoqcBx83FmN=0Rt0NGfeWSj8AYVNeFNugDejR4_3=nVXAeA@mail.gmail.com> <alpine.LNX.2.00.1211072147040.27271@pobox.suse.cz>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Wed, 7 Nov 2012 16:58:33 -0500
Message-ID: <CA+1xoqdwZHH=VMKvddr8bhceQHz+F5Xm5rgwJACUcnH+-uQjdg@mail.gmail.com>
Subject: Re: [GIT] floppy
To: Jiri Kosina <jkosina@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 7, 2012 at 3:48 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Wed, 7 Nov 2012, Sasha Levin wrote:
>
>> Hi guys!
>>
>> This is me complaining that I still see the spews that this pull
>> request should fix, probably because this mail got lost.
>
> You are seeing that on -next, right?

Yup.

> That's because a different version of the patchset has been pushed to
> Linus, but for-next branch in Jens' tree still contains the old patchset
> containing the faulty patch (which is never going upstream).
>
> The fixed series is now in Linus' tree (as per -rc4), and I guess you are
> not having the problem there, right?

I haven't thought of trying just Linus's tree because I thought that
the original patch
that causes the breakage didn't make it there, so it would be obvious
that it would
work fine.

I'll give it a go I guess.


Thanks,
Sasha
