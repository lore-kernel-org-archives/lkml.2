Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823Ab1HHCZr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 22:25:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48094 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751811Ab1HHCZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 22:25:45 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 7 Aug 2011 19:25:22 -0700
Message-ID: <CA+55aFwkJdyEpyNY64aAQ5ChrPZ8Kvx9iRUwy1J6_SRaxoN=zA@mail.gmail.com>
Subject: Linux 3.1-rc1
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's been slightly over two weeks, but I decided that I wanted to do
the release from home rather than from vacation, so you guys got a few
extra days of merging. And some of you took advantage of it too. Tssk,
tssk.

Anyway, 3.1 is shaping up to be a pretty normal release. Almost 75% of
the patch is in drivers, 12% arch updates, and the rest miscellaneous:
fs, net, Documentation.

Of the drivers, about 40% is in staging, 20% networking, and 10%
sound. With scsi, media, etc bringing up the rear. A good chunk of it
was cleanups. And the good news is that the bulk of staging was
removal. The bad news is that we sure made up for it in other areas ;)

Notable? It depends on what you look for. VM writeback work? You got
it. And there was some controversy over the iscsi target code. There's
networking changes, there's the rest of the generic ACL support moving
into the VFS layer proper, simplifying the filesystem code that was
often cut-and-paste duplicated boiler plate. And making us faster at
doing it at the same time. And there are power management interface
cleanups.

But there's nothing *huge* here. Looks like a fairly normal release,
as I said. Unless I've forgotten something.

Go out and test it. Oh, except right now you are probably better off
not enabling SLUB debugging unless you want to help test it.

                                 Linus
