Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303Ab1EBSDN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 14:03:13 -0400
Received: from mail.skyhub.de ([78.46.96.112]:39122 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752233Ab1EBSDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 14:03:09 -0400
Message-ID: <2b5d75ba05bd7889ac80514015e36ad2.squirrel@www.skyhub.de>
In-Reply-To: <BANLkTi==Tx6sXcA2Bk6Cp7wc1DY-7c1V3g@mail.gmail.com>
References: <71633.1304013549@localhost>
    <1304083893-18849-1-git-send-email-mmarek@suse.cz>
    <BANLkTikMf4x0e3UhabUH+c_xnWJMQ3rkvg@mail.gmail.com>
    <20110502170736.GB18740@merkur.ravnborg.org>
    <BANLkTi==Tx6sXcA2Bk6Cp7wc1DY-7c1V3g@mail.gmail.com>
Date: Mon, 2 May 2011 20:03:05 +0200 (CEST)
Subject: Re: [PATCH] kbuild: Allow to combine multiple W= levels
From: boris@alien8.de
To: "Arnaud Lacombe" <lacombar@gmail.com>
Cc: "Sam Ravnborg" <sam@ravnborg.org>,
        =?iso-8859-15?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        "Michal Marek" <mmarek@suse.cz>, valdis.kletnieks@vt.edu, bp@alien8.de,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        davej@redhat.com
User-Agent: SquirrelMail/1.4.15
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm really getting tired of this!

> Because you are not even sure of what you submitted is good for the kernel
> ?

No, because we need to get a feeling of what makes sense for all these
options first. I'd rather do the learning-by-doing thing here and
implement what makes sense than braindead frameworks.

> I think this has been done completely wrong, first all the extra
> warnings got in (without a detailed impact implied by each one),

WTF? http://marc.info/?l=linux-kbuild&m=130346037604547&w=2

No one else did check those and said, ACK/NACK so we went in with this
initial splitting first.

> then it was decided to be split in several level (which I proposed on
> Feb 20th, but was originally rejected by Borislav Petkov),

Of course, because it made no sense at the time. Sam added it later with
his proposal patch.

> then, well, some may need to be removed because they are not good for
> Linux.

have you even tried all those options and come up with concrete
suggestions on which options should go in and which shouldn't, and for
what reasons? I don't think so. So until you do, I don't care what you
have to say.

[snip a bunch of bullshit]

> Now, the drawback of your comment is that when it will be time to
> change the interface, some will object because it will have been
> started to be used by third party scripts, and as authors of third
> party script, it is a PITA to have to check the kernel version to know
> if I should W=1,2,3, or W=123 or if W=3 includes W=1 ...

This is exactly why we're trying to get a feeling of this by _running_
it and _then_ _bitching_ about it. And this is for DEVELOPERS only - if
they've introduced it in their scripts, then they should be able to fix
any changes very easily.

