Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429Ab2CAAIi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 19:08:38 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:35319 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754283Ab2CAAIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 19:08:37 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus971@gmail.com designates 10.180.84.170 as permitted sender) smtp.mail=linus971@gmail.com; dkim=pass header.i=linus971@gmail.com
MIME-Version: 1.0
In-Reply-To: <CAFR8uef08sDCR=FM_v4EV0CLX9f4UuJezSTPFX6V7T-4b7xBVQ@mail.gmail.com>
References: <CAFR8uef08sDCR=FM_v4EV0CLX9f4UuJezSTPFX6V7T-4b7xBVQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 29 Feb 2012 16:08:15 -0800
X-Google-Sender-Auth: FLJklQgUH0Ghvx36GgV4ms4hQNQ
Message-ID: <CA+55aFwnF9Vu3JU6wuGMSeSiQqXrH+hqsZ2Ux79+2eH3A+_5MA@mail.gmail.com>
Subject: Re: [PATCH] Fix setting bio flags in drivers (sd_dif/floppy).
To: Muthu Kumar <muthu.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        martin.petersen@oracle.com, Matt Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 3:22 PM, Muthu Kumar <muthu.lkml@gmail.com> wrote:
> Fix setting bio flags in drivers (sd_dif/floppy).

A quick grep seems to agree that these are the only obvious ones.

Jens? Will you send this to me, or should I take it directly?

And when did Andrew change his name? Nobody tells me these things.

                        Linus
