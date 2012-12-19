Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086Ab2LSGxo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 01:53:44 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:40884 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab2LSGx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 01:53:29 -0500
MIME-Version: 1.0
In-Reply-To: <20121218191633.GB24548@google.com>
References: <1354568322-29029-1-git-send-email-koverstreet@google.com>
	<20121213211808.GJ25017@kernel.dk>
	<CA+res+SKXjXTgrxPaj+kuekd-CZMp4POkSpsdJ7Csfg0HsD=bA@mail.gmail.com>
	<50CAD6D9.5070703@fusionio.com>
	<20121215092526.GA10411@moria.home.lan>
	<50CC46F8.3070600@fusionio.com>
	<20121215103658.GB10411@moria.home.lan>
	<50CC7840.4090403@fusionio.com>
	<20121218191633.GB24548@google.com>
Date: Tue, 18 Dec 2012 22:45:32 -0800
Message-ID: <CAH+dOxJonSqq+RK-eTrPD0ik=xJSQrNXTUgzsj3RoW4V1De6tg@mail.gmail.com>
Subject: Re: [PATCH 00/26] AIO performance improvements/cleanups, v2
From: Kent Overstreet <koverstreet@google.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Jack Wang <jack.wang.usish@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "zab@redhat.com" <zab@redhat.com>, "bcrl@kvack.org" <bcrl@kvack.org>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 11:16 AM, Kent Overstreet
<koverstreet@google.com> wrote:
> Or maybe just getting rid of the ringbuffer is that awesome. Gonna try
> and work on combining our optimizations so I can see what that looks
> like :)


Yes, yes it is. Combined our aio/dio patches and got 50% better
throughput than I'd seen before.
