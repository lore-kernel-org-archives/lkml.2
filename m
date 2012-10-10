Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757780Ab2JJDTX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 23:19:23 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:59547 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010Ab2JJDTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 23:19:21 -0400
MIME-Version: 1.0
In-Reply-To: <20121004201704.36d35755@pyramind.ukuu.org.uk>
References: <506C562E.5090909@redhat.com>
	<CA+55aFweE2BgGjGkxLPkmHeV=Omc4RsuU6Kc6SLZHgJPsqDpeA@mail.gmail.com>
	<20121003170907.GA23473@ZenIV.linux.org.uk>
	<CA+55aFw0pB99ztq5YUS56db-ijdxzevA=mvY3ce5O_yujVFOcA@mail.gmail.com>
	<20121003195059.GA13541@kroah.com>
	<CA+55aFwjyABgr-nmsDb-184nQF7KfA8+5kbuBNwyQBHs671qQg@mail.gmail.com>
	<3560b86d-e2ad-484d-ab6e-2b9048894a12@email.android.com>
	<CA+55aFwVFtUU4TCjz4EDgGDaeR_QwLjmBAJA0kijHkQQ+jxLCw@mail.gmail.com>
	<CAPXgP1189dn=vHqWrp1JgHs7Yv=BP3dbLyT3zb31Sp8mcEhAvg@mail.gmail.com>
	<87zk42tab4.fsf@xmission.com>
	<20121004174254.GA14301@kroah.com>
	<20121004201704.36d35755@pyramind.ukuu.org.uk>
Date: Wed, 10 Oct 2012 05:19:19 +0200
Message-ID: <CAMP44s0TL+d6dOdScmoBR=hE8Jf_KZ_A+KHOJfHQD=p+0k+ZbQ@mail.gmail.com>
Subject: Re: udev breakages -
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Kay Sievers <kay@vrfy.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Walls <awalls@md.metrocast.net>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ming Lei <ming.lei@canonical.com>,
        Lennart Poettering <lennart@poettering.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay@redhat.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Ivan Kalvachev <ikalvachev@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 4, 2012 at 9:17 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> I don't know how to handle the /dev/ptmx issue properly from within
>> devtmpfs, does anyone?  Proposals are always welcome, the last time this
>> came up a week or so ago, I don't recall seeing any proposals, just a
>> general complaint.
>
> Is it really a problem - devtmpfs is optional. It's a problem for the
> userspace folks to handle and if they made it mandatory in their code
> diddums, someone better go fork working versions.

If only there was a viable alternative to udev.

Distributions are being pushed around by the udev+systemd project
precisely because of this reason; udev maintainers have said that udev
on non-systemd systems is a dead end, so everyone that uses udev
(everyone) is being forced to switch to systemd if they want to
receive proper support, and at some point there might not be even a
choice.

I for one would like an alternative to both systemd and udev on my
Linux systems, and as of yet, I don't know of one.

Cheers.

-- 
Felipe Contreras
