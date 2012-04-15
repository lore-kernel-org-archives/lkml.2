Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122Ab2DOR3o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 13:29:44 -0400
Received: from 1wt.eu ([62.212.114.60]:65204 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755732Ab2DOR3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 13:29:43 -0400
Date: Sun, 15 Apr 2012 19:29:10 +0200
From: Willy Tarreau <w@1wt.eu>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>, Sergio Correia <lists@uece.net>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ 00/78] 3.3.2-stable review
Message-ID: <20120415172910.GE27728@1wt.eu>
References: <CA+55aFwKYYgZcBX=L-q_6UdvkvFai+yjzgVxq7cA+HLL-Zojhw@mail.gmail.com> <CAMP44s14SQont1wyMeOuWcXUT3U5Tgnoj9mbbgOdVXY_hN0+-w@mail.gmail.com> <CA+55aFyLEJsz1yvu4bYe+RHdhLd-XXEScxtAgje=fyuUM+1XxA@mail.gmail.com> <CAMP44s0yPPqFUO4963MhNb8+c_A=xJi4-eFPJ3s+a1TJ8ZfTtQ@mail.gmail.com> <CA+55aFwaOGbD6S_7So34ZuANG-6fZXZhEah8G0X7McDGhionSg@mail.gmail.com> <CAMP44s06jrPBzf5Lt86-GDxD_PxqcaeJgmYS4tJhcvDdf=J5zA@mail.gmail.com> <20120414104733.GA4871@gmail.com> <CAMP44s0tBbgmunXTN9Jyw=HHnXFyvRY3qo5Vf-jXETUM4HEGWA@mail.gmail.com> <20120415065124.GC29563@gmail.com> <CAMP44s3mOsCGG5_gd6zTUeXewTFKeVEmAkt2FvM=wTm-5AEC+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMP44s3mOsCGG5_gd6zTUeXewTFKeVEmAkt2FvM=wTm-5AEC+w@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe,

On Sun, Apr 15, 2012 at 08:15:23PM +0300, Felipe Contreras wrote:
(...)
> Why is it that the patch from yesterday doesn't reduce the version
> skew, but the patch from today does? You are not explaining *why*.

Severl of us have explained to you multiple times *why*. Either you're
having a parsing problem, or you don't understand anything to versionning
but in all cases you should try to educate yourself a minimum before
repeating the same question in loops.

> It's like I'm asking why the freezer area is different from the normal
> refrigerator area, and you are saying; well it's colder, it's usually
> smaller, and it makes all food taste better. So you are either just
> describing the differences without explaining the reason (being colder
> helps for some foods), or you are providing an unsubstantiated claim;
> you go from a) it's colder, to b) it makes all food taste better. And
> when asked *why* again, you repeat, well, because it's colder. And
> then you immediately go to the conclusion; therefore you should put as
> much food in the freezer as possible.

No, it's quite the opposite, almost everyone in this thread explained to
you that bacteria don't develop in cold and that's the reason it's better
to keep food. But you deliberately (or maybe inconsciously because you
don't know what bacteria are) wipe out these explanations and pretend
nobody explained the reason to you. 

Please re-read all responses, everything is there. I thought my explanation
was detailed enough to understand why it works that way, and Ingo explained
it in great details again. So please now make an effort to try to read what
people explain and stop pretending they refuse to respond, that's getting
really irritating.

The fact that you're the only one to ask this in loops should ring a bell,
it seems like many people managed to understand, either before this thread
or during this thread. It's up to you, I don't think that insisting on
people to explain the same things to you in many different ways will solve
your problems, really.

Regards,
Willy

