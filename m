Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760169Ab0I0U3R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 16:29:17 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:53396 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755362Ab0I0U3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 16:29:15 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: =?utf-8?Q?Pawe=C5=82?= Sikora <pluto@agmk.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: git bisect selects commit outside initial bisect range?
References: <201009272051.33882.pluto@agmk.net>
X-Yow: As President I have to go vacuum my coin collection!
Date: Mon, 27 Sep 2010 22:29:13 +0200
In-Reply-To: <201009272051.33882.pluto@agmk.net> (=?utf-8?Q?=22Pawe=C5=82?=
 Sikora"'s message of
	"Mon, 27 Sep 2010 20:51:33 +0200")
Message-ID: <m2fwwv7wx2.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paweł Sikora <pluto@agmk.net> writes:

> i've started git bisect between good-v2.6.34 and bad-v2.6.35-rc1
> and after few steps git-bisect jumps to commit before v2.6.34.
>
> [~/src/linux/linux-2.6]$ make kernelrelease
> 2.6.34-rc6-00551-g7a6cb0d
>
> is it normal that bisect selects next step outside initial range?

It's not outside the range:

$ git rev-list v2.6.34..v2.6.35-rc1 | grep ^7a6cb0d
7a6cb0d5497418599d2125b670926b75e673861c

7a6cb0d is a commit in a branch reachable from v2.6.35-rc1 but not from
v2.6.34.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
