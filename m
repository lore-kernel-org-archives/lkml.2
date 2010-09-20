Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363Ab0ITNXn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 09:23:43 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:45469 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753728Ab0ITNXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 09:23:42 -0400
Message-ID: <4C976060.1010008@kernel.dk>
Date: Mon, 20 Sep 2010 15:23:44 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Corrado Zoccolo <czoccolo@gmail.com>
CC: Linux-Kernel <linux-kernel@vger.kernel.org>,
        Jeff Moyer <jmoyer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] cfq: improve fsync performance for small files
References: <201007202209.04627.czoccolo@gmail.com> <AANLkTinajj76EBUQE6RXeQmZ9AEWU1g3x+pyW3Cmku0x@mail.gmail.com>
In-Reply-To: <AANLkTinajj76EBUQE6RXeQmZ9AEWU1g3x+pyW3Cmku0x@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-09-12 16:40, Corrado Zoccolo wrote:
> Hi Jens,
> any comment on this patch, or the problem we are trying to solve?

I have queued it up for .37.

-- 
Jens Axboe

