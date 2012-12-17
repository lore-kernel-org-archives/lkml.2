Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab2LQT1d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 14:27:33 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:49755 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239Ab2LQT1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 14:27:32 -0500
MIME-Version: 1.0
In-Reply-To: <50CF6D35.5040300@kernel.dk>
References: <50CF3B82.9000904@kernel.dk> <x49licwwtm8.fsf@segfault.boston.devel.redhat.com>
 <20121217170016.GA2592@htj.dyndns.org> <50CF50AA.7080600@kernel.dk>
 <x49ehiowqga.fsf@segfault.boston.devel.redhat.com> <50CF6D35.5040300@kernel.dk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 17 Dec 2012 11:27:10 -0800
X-Google-Sender-Auth: ruma1m1dLYMwA4udjkJuKcK74kg
Message-ID: <CA+55aFxoN+4Nu1YB=b+3eTWKq=_h_cN5i2DVzeYCEqNyN_PwZA@mail.gmail.com>
Subject: Re: [GIT PULL] core block IO bits for 3.8
To: Jens Axboe <axboe@kernel.dk>
Cc: Jeff Moyer <jmoyer@redhat.com>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 11:06 AM, Jens Axboe <axboe@kernel.dk> wrote:
>
> Sigh, in that case, yes lets just revert it.

So just to check - we're talking about commit 8fa72d234da9 ("bdi: add
a user-tunable cpu_list for the bdi flusher threads"). It reverts
cleanly, but I wanted to make sure we're all on the same page..

            Linus
