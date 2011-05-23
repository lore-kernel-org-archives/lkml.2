Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757840Ab1EWXeJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 19:34:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58461 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755782Ab1EWXeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 19:34:05 -0400
MIME-Version: 1.0
In-Reply-To: <4DDAEC68.30803@zytor.com>
References: <BANLkTi=PLuZhx1=rCfOtg=aOTuC1UbuPYg@mail.gmail.com>
 <20110523192056.GC23629@elte.hu> <BANLkTikdgM+kSvaEYuQkgCYJZELnvwfetg@mail.gmail.com>
 <20110523231721.GM10009@thunk.org> <4DDAEC68.30803@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 23 May 2011 16:33:12 -0700
Message-ID: <BANLkTikGfVSAMY2a2yiXaNpvBVvF8YdMEA@mail.gmail.com>
Subject: Re: (Short?) merge window reminder
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Ted Ts'o" <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org, DRI <dri-devel@lists.freedesktop.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another advantage of switching numbering models (ie 3.0 instead of
2.8.x) would be that it would also make the "odd numbers are also
numbers" transition much more natural.

Because of our historical even/odd model, I wouldn't do a 2.7.x -
there's just too much history of 2.1, 2.3, 2.5 being development
trees. But if I do 3.0, then I'd be chucking that whole thing out the
window, and the next release would be 3.1, 3.2, etc..

And then in another few years (probably before getting close to 3.40,
so I'm not going to make a big deal of 3 = "third decade"), I'd just
do 4.0 etc.

Because all our releases are supposed to be stable releases these
days, and if we get rid of one level of numbering, I feel perfectly
fine with getting rid of the even/odd history too.

                      Linus
