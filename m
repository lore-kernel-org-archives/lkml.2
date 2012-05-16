Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826Ab2EPPZa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 11:25:30 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59049 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950Ab2EPPZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 11:25:29 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1205160932280.8796@pobox.suse.cz>
References: <alpine.LNX.2.00.1205160932280.8796@pobox.suse.cz>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 16 May 2012 08:25:06 -0700
X-Google-Sender-Auth: ZCM74LKEtsnA4yJIds9um1ntU5U
Message-ID: <CA+55aFwP=-tgNfQSkV2HMdYXdaWZzSTLzvyLJ8cBEosh_zGwMw@mail.gmail.com>
Subject: Re: [PATCH] floppy: convert to delayed work and single-thread wq
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
        Stephen Hemminger <shemminger@vyatta.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 12:36 AM, Jiri Kosina <jkosina@suse.cz> wrote:
>
> This patch converts all the timers and bottom halfs to be processed in a
> single workqueue. This aproach has been already discussed back in 2010 and
> Acked by Linus [1], but it then never made it to the tree.

Nobody ever actually reported testing it on real hardware, and I
didn't want to take it untested.

Since you have tested this, I will have *zero* problems with taking it for 3.5.

                     Linus
