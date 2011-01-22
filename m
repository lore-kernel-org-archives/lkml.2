Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab1AVO1V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 09:27:21 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57344 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753197Ab1AVO1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 09:27:20 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTikaB_A7Oc+AvheGc3bEgTQUQ_KqiVp7Jwup=5-4@mail.gmail.com>
References: <AANLkTi=bxD0wpJ9o1G5V2rOd4TtHsGS0LuePNXPaWJg9@mail.gmail.com>
 <4D3ABA37.2040900@example.com> <AANLkTikaB_A7Oc+AvheGc3bEgTQUQ_KqiVp7Jwup=5-4@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 22 Jan 2011 06:26:56 -0800
Message-ID: <AANLkTiksnC_v_pwxemGH26_iYT6DrYCMQOa9KQjHk2vk@mail.gmail.com>
Subject: Re: 2.6.38-rc2 tarballs? XZ-compressed source tarballs?
To: sedat.dilek@gmail.com
Cc: piotr@hosowicz.com, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 22, 2011 at 3:30 AM, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
>
> I had to be more precise... there is only TAR.GZ tarball [1].

So the *.gz parts are the only thing I ever upload. Everything else is
done by scripts that run automatically.

And it does seem like the scripts aren't running right now. I'll ping
the responsible people..

           Linus
