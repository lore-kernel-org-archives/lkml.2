Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378Ab1KOThO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 14:37:14 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54150 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757304Ab1KOThL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 14:37:11 -0500
MIME-Version: 1.0
In-Reply-To: <4EC2BCE2.4050105@xenotime.net>
References: <CA+55aFzWkXNtLe4jxuXfTJzbXgDF+ig2OuGY3ca+nNCJxAtOZQ@mail.gmail.com>
 <4EC2BCE2.4050105@xenotime.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 15 Nov 2011 17:36:49 -0200
X-Google-Sender-Auth: N7vvFD_TM40Kep0iMEXYFVOf500
Message-ID: <CA+55aFzhM8eB6wjtpeCpLmZJN7n-wZ9AoZeRic=-i-kNKa-KTQ@mail.gmail.com>
Subject: Re: Linux 3.2-rc2
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 5:26 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
>
> still uploading?  I don't see the patch file(s) at all.

My internet connection while travelling is too slow, and I aborted it.
The tar-file can be remotely generated (and I can upload just a
matching signature), but the diffs aren't stable enough for that (the
same physical difference can be shown many different ways - and in a
big diff usually is).

I'm trying to match git versions and get a matching diff, but if worst
comes to worst it will be two days before I get to Sao Paulo and
(presumably) a reasonable internet connection.

The funny thing is, I never had trouble with git. Git is so efficient
wrt network bandwidth that the really sucky connection never mattered
for real work. It's literally just uploading a big diff (largely the
network driver renames) that takes too long to be worth it.

           Linus
