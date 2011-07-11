Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254Ab1GKUvT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 16:51:19 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:63193 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab1GKUvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 16:51:18 -0400
MIME-Version: 1.0
In-Reply-To: <4E1B615B.3040509@gmail.com>
References: <201107082028.p68KSWWf013053@imap1.linux-foundation.org>
	<4E1B5CAA.7070001@gmail.com>
	<20110711134121.54557e28.akpm@linux-foundation.org>
	<CAOJsxLG3jjjebBPbZjWTzue7nZJFMWVGZ3iGK41cjGpdKi477Q@mail.gmail.com>
	<4E1B615B.3040509@gmail.com>
Date: Mon, 11 Jul 2011 23:51:17 +0300
X-Google-Sender-Auth: o-Yqz5w_lfan2rtIoNp9R9VnjwU
Message-ID: <CAOJsxLH-3oYgSXO+sNs23+MBeKMsFitkMpHn8LXz=vBZHb2i4g@mail.gmail.com>
Subject: Re: page->_count build failure [was: mmotm 2011-07-08-12-50 uploaded]
From: Pekka Enberg <penberg@kernel.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        cl@linux.com, Pekka Enberg <penberg@cs.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 11:47 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
>> Didn't commit ea6bd8ee1a2ccdffc38b2b1fcfe941addfafaade fix the issue?
>
> Which repo is that from? Git doesn't know it here.

It's in slab.git:

http://git.kernel.org/?p=linux/kernel/git/penberg/slab-2.6.git;a=commitdiff;h=ea6bd8ee1a2ccdffc38b2b1fcfe941addfafaade

Maybe linux-next hasn't picked it up yet?
