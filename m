Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340Ab0GYWy5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 18:54:57 -0400
Received: from norkia.v3.sk ([91.210.183.14]:52797 "EHLO norkia.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751711Ab0GYWy4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 18:54:56 -0400
Subject: Re: [PATCH] V7: Add support for non-PDP11 v7 filesystems
From: Lubomir Rintel <lkundrak@v3.sk>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@lst.de>
In-Reply-To: <1280098246-26293-1-git-send-email-lkundrak@v3.sk>
References: <1280098246-26293-1-git-send-email-lkundrak@v3.sk>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Jul 2010 00:54:30 +0200
Message-ID: <1280098470.3910.21.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-07-26 at 00:50 +0200, Lubomir Rintel wrote:
> A mount-time option was added that makes it possible to override the
> endianness and an attempt is made to autodetect it (which seems easy,
> given the disk addresses are 3-byte.
> 
> No attempt is made to detect big-endian filesystems -- were there any?
> Tested with PDP-11 v7 filesystems and PC-IX maintenance floppy.

This should have been a reply to
<20100724135128.GA11645@ZenIV.linux.org.uk>
Moreover it has a bad commit message; By bad, please ignore this one.

sorry
-- 
Flash is the Web2.0 version of blink and animated gifs.
                                     -- Stephen Smoogen

