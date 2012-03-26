Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131Ab2CZWft (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 18:35:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36012 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757528Ab2CZWfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 18:35:48 -0400
Date: Mon, 26 Mar 2012 15:35:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arkadiusz =?UTF-8?Q?Mi=C5=9Bkiewicz?= <a.miskiewicz@gmail.com>
Cc: Vasiliy Kulikov <segoon@openwall.com>, linux-kernel@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] proc: fix mount -t proc -o AAA
Message-Id: <20120326153546.c1525462.akpm@linux-foundation.org>
In-Reply-To: <201203250924.06908.a.miskiewicz@gmail.com>
References: <201203220903.15360.a.miskiewicz@gmail.com>
	<20120323171058.GA3279@albatros>
	<20120323161504.dced28b9.akpm@linux-foundation.org>
	<201203250924.06908.a.miskiewicz@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Mar 2012 09:24:06 +0200
Arkadiusz Mi__kiewicz <a.miskiewicz@gmail.com> wrote:

> > I redid the changelog:
> > 
> > 
> > From: Vasiliy Kulikov <segoon@openwall.com>
> > Subject: proc: fix mount -t proc -o AAA
> > 
> > The proc_parse_options() call from proc_mount() runs only once at boot
> > time.  So on any later mount attempt, any mount options are ignored
> > because ->s_root is already initialized.
> > 
> > As a consequence, "mount -o remount,<options>" will ignore the options.
> 
> So this changelog doesn't match what I saw.

So could someone please send a changelog which *does* match what you
saw?  The original remains incomprehensible :(



