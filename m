Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab1FCMGD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 08:06:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2886 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751515Ab1FCMGB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 08:06:01 -0400
From: Andreas Schwab <schwab@redhat.com>
To: Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: git torvalds/linux-2.6.git  gives obscure results
References: <201106031317.35112.toralf.foerster@gmx.de>
X-Yow: Where's the Coke machine?  Tell me a joke!!
Date: Fri, 03 Jun 2011 14:05:55 +0200
In-Reply-To: <201106031317.35112.toralf.foerster@gmx.de> ("Toralf
 =?utf-8?Q?F=C3=B6rster=22's?=
	message of "Fri, 3 Jun 2011 13:17:34 +0200")
Message-ID: <m38vtjglwc.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Toralf Förster <toralf.foerster@gmx.de> writes:

> at the command line. And within a sniffed network stream w/ wireshark I can 
> see something like :
>
> 0059git-upload-pack 
> /pub/scm/linux/kernel/git/torvalds/linux-2.6.git.host=git.kernel.org.git: 
> 'daemon' is not a git command. See 'git --help'.

Odd thing is that it only fails like that half of the time.

Andreas.

-- 
Andreas Schwab, schwab@redhat.com
GPG Key fingerprint = D4E8 DBE3 3813 BB5D FA84  5EC7 45C6 250E 6F00 984E
"And now for something completely different."
