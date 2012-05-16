Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965246Ab2EPToV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 15:44:21 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:65453 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964964Ab2EPToS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 15:44:18 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1205162133180.8796@pobox.suse.cz>
References: <alpine.LNX.2.00.1205160932280.8796@pobox.suse.cz>
 <20120516170124.GA21275@google.com> <alpine.LNX.2.00.1205162133180.8796@pobox.suse.cz>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 16 May 2012 12:43:57 -0700
X-Google-Sender-Auth: tIb9eME2Q6V-Qbo5NWh28ICtNEE
Message-ID: <CA+55aFyfnRpKNS+0LhvBZC=ixYZ4uD-=zB1kPZxec1vo50qFcQ@mail.gmail.com>
Subject: Re: [PATCH] floppy: convert to delayed work and single-thread wq
To: Jiri Kosina <jkosina@suse.cz>
Cc: Stephen Hemminger <shemminger@vyatta.com>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 12:37 PM, Jiri Kosina <jkosina@suse.cz> wrote:
>
> Thanks. From your responses I gather that there is actually a slight
> problem with not enough real floppy drives being owned by kernel people.

Absolutely. We've had bug-reports about floppies not working, with no
real way to do anything about it.

In fact, I would even mark the patch for stable@vger.kernel.org,
although I'd like it to be in 3.5 for a while before actually
backported. Exactly because we *have* had reports of problems, even
though I think they've mostly been in VM's.

> As I currently still own quite a few machines with those drives, I can
> eventually take over some kind of floppy.c maintainership if necessary.

You'll have to fight the current maintainer to the death in the Thunderdome.

What's that, you say? Oh, that there is no current maintainer? Oh,
well. I guess you won't have to fight anybody then.

Tag, you're it.

                    Linus
