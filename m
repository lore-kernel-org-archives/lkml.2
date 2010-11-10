Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab0KJCCR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 21:02:17 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46750 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104Ab0KJCCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 21:02:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=EAftBjc8+3Hz/hPsv2Srl6XpoXcASQXBPKg9t6tOzVRhNz5eU3qfYpUQmSyVCd5WQQ
         1wDoypZ6gPUCigwQcDbtHSu03yxbM5MSN4FK2/IARQhsJ5DHsLQXIQ4Q4ikZzXSFuwdC
         qMrrXrrUIo3JIrNQ6f+tzIsb91m2YCIwcdfRU=
MIME-Version: 1.0
In-Reply-To: <20101110013255.GR2715@dastard>
References: <20101105014334.GF13830@dastard> <E1PELiI-0001Pj-8g@approx.mit.edu>
 <AANLkTimON_GL6vRF9=_U6oRFQ30EYssx3wv5xdNsU9JM@mail.gmail.com>
 <4CD696B4.6070002@kernel.dk> <AANLkTikNPEcwWjEQuC-_=9yH5DCCiwUAY265ggeygcSQ@mail.gmail.com>
 <20101110013255.GR2715@dastard>
From: dave b <db.pub.mail@gmail.com>
Date: Wed, 10 Nov 2010 13:01:55 +1100
Message-ID: <AANLkTim1PSgY1ZFv2VOAg96Tc+VJiZefLeu8qDZ2fRTS@mail.gmail.com>
Subject: Re: 2.6.36 io bring the system to its knees
To: Dave Chinner <david@fromorbit.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Sanjoy Mahajan <sanjoy@olin.edu>,
        Jesper Juhl <jj@chaosbits.net>, Chris Mason <chris.mason@oracle.com>,
        Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@kernel.org>,
        Aidar Kultayev <the.aidar@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
        Arjan van de Ven <arjan@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, "Ted Ts'o" <tytso@mit.edu>,
        Corrado Zoccolo <czoccolo@gmail.com>,
        Shaohua Li <shaohua.li@intel.com>, Steven Barrett <damentz@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok so all of us on ext3 should just up and move to ext4 ^ ^ ? (who
want to avoid these problems)
