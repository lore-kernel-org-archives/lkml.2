Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757188Ab0KJRKU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 12:10:20 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:52351 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757149Ab0KJRKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 12:10:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ME/sD4Pr2jwpzuEcW5mHcvmpIauYVrkudsA71wGvNx+g+DNEJNX6oixyHfL7Cdrvfe
         O1YkUQ9FwIzugE98HueH+pHeNYRSZrRSqNsFs+RYssujOFuvRMpqxm+iZy26ZIDVhpgk
         kMKh9GJ0cG5soac2J8Y/iImi4Dc3zQ1fMiCEQ=
MIME-Version: 1.0
In-Reply-To: <AANLkTik1zyrP5DBGC+MmSKF2Eeep3fSu=-8TdOY8BTJj@mail.gmail.com>
References: <20101105014334.GF13830@dastard>
	<E1PELiI-0001Pj-8g@approx.mit.edu>
	<AANLkTimON_GL6vRF9=_U6oRFQ30EYssx3wv5xdNsU9JM@mail.gmail.com>
	<4CD696B4.6070002@kernel.dk>
	<AANLkTikNPEcwWjEQuC-_=9yH5DCCiwUAY265ggeygcSQ@mail.gmail.com>
	<20101110013255.GR2715@dastard>
	<AANLkTinpLuzd5c+WqXoa_0Z=nv=mDgd-k4QZbBZHsQnD@mail.gmail.com>
	<AANLkTinYZ2wPeeunFv4Ljm+D9SDLbgzTVmw_P9KQdK16@mail.gmail.com>
	<AANLkTik1zyrP5DBGC+MmSKF2Eeep3fSu=-8TdOY8BTJj@mail.gmail.com>
Date: Wed, 10 Nov 2010 19:10:17 +0200
Message-ID: <AANLkTi=8uwjAqSmMWbAwX1gGbjS8Q8Rh1mPu7RArdLJt@mail.gmail.com>
Subject: Re: 2.6.36 io bring the system to its knees
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, Jens Axboe <axboe@kernel.dk>,
        dave b <db.pub.mail@gmail.com>, Sanjoy Mahajan <sanjoy@olin.edu>,
        Jesper Juhl <jj@chaosbits.net>, Chris Mason <chris.mason@oracle.com>,
        Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@kernel.org>,
        Aidar Kultayev <the.aidar@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
        Arjan van de Ven <arjan@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, "Ted Ts'o" <tytso@mit.edu>,
        Corrado Zoccolo <czoccolo@gmail.com>,
        Shaohua Li <shaohua.li@intel.com>, Steven Barrett <damentz@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 6:55 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Nov 10, 2010 at 8:46 AM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
>> Those of us, who did (without UPS), will never do it again.
>
> Before or after the change to make renaming on top of old files do the
> IO flushing?

It was long ago, so before patch.

> That made a big difference for some rather common cases.

That's good.
Maybe, it's only an order of magnitude likely to lose FS now instead of several.
:-)
