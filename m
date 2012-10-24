Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757789Ab2JXPxx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 11:53:53 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:59211 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab2JXPxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 11:53:52 -0400
From: "Justin Piszcz" <jpiszcz@lucidpixels.com>
To: <tytso@mit.edu>, "'Steven J. Magnani'" <steve@digidescorp.com>
Cc: <linux-kernel@vger.kernel.org>
References: <1351085817.2362.2.camel@iscandar> <002101cdb1e1$47972c60$d6c58520$@lucidpixels.com> <20121024144025.GA30955@thunk.org>
In-Reply-To: <20121024144025.GA30955@thunk.org>
Subject: RE: 3.6.0 kernel - ext4 corruption, or?
Date: Wed, 24 Oct 2012 11:53:47 -0400
Message-ID: <009201cdb1ff$c33d8c60$49b8a520$@lucidpixels.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQElwWCuRA+s4lQJJiW862BUB3QrZ5kYe7MA
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



-----Original Message-----
From: tytso@mit.edu [mailto:tytso@mit.edu] 
Sent: Wednesday, October 24, 2012 10:40 AM
To: Justin Piszcz; Steven J. Magnani
Cc: linux-kernel@vger.kernel.org
Subject: Re: 3.6.0 kernel - ext4 corruption, or?

On Wed, Oct 24, 2012 at 08:15:37AM -0400, Justin Piszcz wrote:
> 
> I read there was a bug in 3.6.2, is there also one in 3.6.0, or can
someone
> help explain this?

The problem which we are currently trying to investigate was
reportedly introduced in v3.6.1.  So far that's about how we know; we
have two users who have reported it, but I and other ext4 developers
haven't been able to reproduce it yet.

Got it.

> # grep 10.0.0.11 -r /etc
> /etc/posfix.old/master.cf:10.0.0.11:smtp         inet  n       -       -
> -        1    postscreen
> 
> # ls -l /etc/posfix.old/master.cf
> -rw-r--r-- 1 root root 13236 Oct 28  2011 /etc/posfix.old/master.cf
> 
> # ls -ld /etc/postfix.old
> ls: cannot access /etc/postfix.old: No such file or directory
> 

Looks like you or some script renamed /etc/postfix to /etc/posfix.old
as part some upgrade?

Whoops-- sorry about that, typo, so for now (concerning the other bug) it's
best to stay with 3.6.0 until the bug is found, thank you.

Justin.

