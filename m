Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932758Ab2EVB62 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 21:58:28 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:42670 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755942Ab2EVB61 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 21:58:27 -0400
MIME-Version: 1.0
In-Reply-To: <20120522013949.GA31883@redhat.com>
References: <20120522011152.GA18115@redhat.com> <20120522013949.GA31883@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 21 May 2012 18:58:05 -0700
X-Google-Sender-Auth: U3tncBvcy1jbe43cIU7tcFTJiBU
Message-ID: <CA+55aFzYd9b4CF30vK+rT_daKLXKBd7kOpsOZtoPKcDnsgYAxA@mail.gmail.com>
Subject: Re: 3.4+ dcache BUG.
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 6:39 PM, Dave Jones <davej@redhat.com> wrote:
>
>        BUG_ON(nd->inode != dentry->d_inode);

I'm going to assume it's the exact same thing (and thus hopefully
fixed by the revert that I just pushed out), but now I'm really
curious what your load is, since you seem to recreate this so easily.
I ran with that patch for weeks.

But I suspect my issue is that while I tested lots of concurrent
lookups, I don't run into low-memory situations.

                    Linus
