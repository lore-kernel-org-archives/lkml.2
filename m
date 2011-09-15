Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934664Ab1IOT5E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 15:57:04 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47598 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934532Ab1IOT5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 15:57:02 -0400
MIME-Version: 1.0
Date: Thu, 15 Sep 2011 21:57:01 +0200
Message-ID: <CA+o4b4fpXtF+LgLREPdjY7N06vwhCdOwRWgn-sQZYhL44=w+zA@mail.gmail.com>
Subject: legal question regarding use of glibc headers in /usr/include/linux
From: David Miller <davemiller2222@googlemail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a question that came up regarding the use of Linux in
proprietary user-space programs.
After several hours searching the web I am even more confused than
before, so I decided to ask someone that should know about.
My company would like to use Linux in an embedded system along with
some proprietary software. I think in general this alone should be
possible. The problem is that I am unsure what headers I can include
within user-space programs and which not. When I install the normal
glibc in Ubuntu (build-essential package) it installs also some linux
kernel headers in /usr/include/linux.
My question now is: Can I include these headers (e.g. #include
<linux/types.h>) since they seem to be normal glibc headers that seem
to be intended to be included in user-space programs that are
proprietary. I mean it's clear that I cannot use the ones in
/usr/src/linux-headers... that are containing the normal Linux Code.

If your answer is no:
------------------------
Why not - these headers contain just facts and how glibc could work
then? In any way glibc must interface with the linux kernel also, or
not? And the glibc is LGPL!
And also how can that be? I can then include accidentally any
forbidden header? From my point of view linux is not maintainable
then!
References:
http://www.osnews.com/story/24553/Does_Android_Violate_the_GPL_Probably_Not
also: the text file linux COPYING in the kernel sources

If your answer is yes:
----------------------
Some of the kernel headers in /usr/include/linux contain a GPL notice
in its header. When I include these headers, my proprietary user-space
program will be forced to be under GPL license and I will be killed by
my boss or not?


I stay tuned and look forward to your answer.

Thanks in advance,
Dave Miller (not the well-known)
