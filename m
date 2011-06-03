Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab1FCMrR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 08:47:17 -0400
Received: from canardo.mork.no ([148.122.252.1]:35673 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555Ab1FCMrQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 08:47:16 -0400
X-Greylist: delayed 908 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Jun 2011 08:47:15 EDT
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>,
        linux-kernel@vger.kernel.org
Subject: Re: git torvalds/linux-2.6.git gives obscure results
Organization: m
References: <201106031317.35112.toralf.foerster@gmx.de>
	<BANLkTikzwD_EeOwX4wSzQ3e3JoWKZb=xgg@mail.gmail.com>
Date: Fri, 03 Jun 2011 14:36:02 +0200
In-Reply-To: <BANLkTikzwD_EeOwX4wSzQ3e3JoWKZb=xgg@mail.gmail.com> (richard's
	message of "Fri, 3 Jun 2011 13:29:28 +0200")
Message-ID: <87lixjxfbh.fsf@nemi.mork.no>
User-Agent: Gnus/5.110017 (No Gnus v0.17) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

richard -rw- weinberger <richard.weinberger@gmail.com> writes:
> 2011/6/3 Toralf Förster <toralf.foerster@gmx.de>:
>> SyncingLinus' tree today gives this error :
>>
>> fatal: protocol error: bad line length character: git:
>>
>
> Same problem here. :-(

Mee too.

There's a problem with the git installation on one of the geo located
git.kernel.org servers, namely git4.kernel.org located at the University
of Umeå:

bjorn@canardo:~$ telnet git4.kernel.org git
Trying 130.239.17.8...
Connected to git4.kernel.org.
Escape character is '^]'.
git: 'daemon' is not a git command. See 'git --help'.
Connection closed by foreign host.


I looked around at www.kernel.org trying to find an address to report
problems with that specific host, but couldn't find one.  So I sent a
report to webmaster.  If anyone sees this, please fix.  Or take git4 out
of the geo service until it is fixed.



Bjørn
