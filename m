Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571Ab1BNSOl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 13:14:41 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57785 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750948Ab1BNSOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 13:14:40 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTimwbkQQkwcX19NVcmSfv5O1dP9oeEBegbQLSh60@mail.gmail.com>
References: <AANLkTimmb26UiBSukdNnVdxLJpCGd=QqpCw8vQoHALh-@mail.gmail.com>
 <m1hbce46fw.fsf@fess.ebiederm.org> <AANLkTikJL_4-7F_2oSuefSpL7ak3+OWLk7F+bDqWT8XJ@mail.gmail.com>
 <m1bp2ly41q.fsf@fess.ebiederm.org> <AANLkTimGH5mU+OLRKb=H3WgLXPZaSc5heR+4w5gj2aD4@mail.gmail.com>
 <AANLkTikj-ZTS58uAqUmKQEWzdD3f5DJeox=gOJ9z8rSb@mail.gmail.com>
 <AANLkTinjsimbe6-YgcSK0-zqDuoZ=8xCReHnKZoG4GU9@mail.gmail.com>
 <m14o87wev8.fsf@fess.ebiederm.org> <AANLkTimO3h80Wk44OhpfkjzxpzdDKnf6emj2fNObn_jD@mail.gmail.com>
 <m1r5bbthan.fsf@fess.ebiederm.org> <m1fwrrtc0m.fsf@fess.ebiederm.org>
 <m139nqsk3q.fsf@fess.ebiederm.org> <AANLkTikt-PhqRHT8+Zp+ZuGoVNaP8G3yqxMHpGZ_Z98w@mail.gmail.com>
 <AANLkTimwbkQQkwcX19NVcmSfv5O1dP9oeEBegbQLSh60@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 14 Feb 2011 10:08:41 -0800
Message-ID: <AANLkTi=CZ8v99yojSb0Ci=5N9dVFr-vDeZM1_Amx_scj@mail.gmail.com>
Subject: Re: Heads up Linux 2.6.38-rc4 compile problems.
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alex Riesen <raa.lkml@gmail.com>, David Miller <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 9:49 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Btw, can you just make that 'vmlinux' image [..]

.. actually, since you have lots of modules, the .config file is a
much better option. If it's in some module, the vmlinux file won't
contain it.

(Although best guess would be for it to be some core data structure,
so who knows?)

                                 Linus
