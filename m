Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab1H2MxE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 08:53:04 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:52105 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727Ab1H2Mw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 08:52:58 -0400
MIME-Version: 1.0
In-Reply-To: <201108291351.06092.philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
	<20110826135402.GS14479@barkeeper1-xen.linbit>
	<CAGZ=bqJojmtfVjQdbx3j2vZyrz01dZZs7wVqBxNbqreejZu4JQ@mail.gmail.com>
	<201108291351.06092.philipp.reisner@linbit.com>
Date: Mon, 29 Aug 2011 15:52:56 +0300
X-Google-Sender-Auth: rDQJMgI49ODmYANm7lVVCfCsmZQ
Message-ID: <CAOJsxLHQFhHaASj9eSJeQ9H_VyS59ztu=caOoUipYEneiB1vAA@mail.gmail.com>
Subject: Re: [Drbd-dev] [RFC 000/118] drbd: part 1 of adding multiple volume
 support to drbd
From: Pekka Enberg <penberg@kernel.org>
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Kyle Moffett <kyle@moffetthome.net>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com,
        Greg Freemyer <greg.freemyer@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 2:51 PM, Philipp Reisner
<philipp.reisner@linbit.com> wrote:
> The new feature set, might be partially broken, but introducing
> the new features is the whole point of this patch series.

If that new feature can, for example, corrupt your data while you're
doing "git bisect" on non-DRBD regression, that's no good. Can that
happen?

                        Pekka
