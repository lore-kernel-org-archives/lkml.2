Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750907Ab1IWRZJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 13:25:09 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:41811 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab1IWRZI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 13:25:08 -0400
MIME-Version: 1.0
In-Reply-To: <1316788285-17433-11-git-send-email-philipp.reisner@linbit.com>
References: <1316788285-17433-1-git-send-email-philipp.reisner@linbit.com> <1316788285-17433-11-git-send-email-philipp.reisner@linbit.com>
From: Kyle Moffett <kyle@moffetthome.net>
Date: Fri, 23 Sep 2011 13:24:48 -0400
Message-ID: <CAGZ=bqJpPOFVbONmRbfww+GYb-9__33wGwbBYN0Gjt+3+w4o5g@mail.gmail.com>
Subject: Re: [PATCH 10/10] drbd: For protocol versions before 100, use mixed
 header versions
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        drbd-dev@lists.linbit.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 23, 2011 at 10:31, Philipp Reisner
<philipp.reisner@linbit.com> wrote:
> Previous versions of drbd are using version 80 headers for all packets
> short enough for protocol 80.  They support both header versions in
> worker context, but only version 80 headers in asynchronous context.
> For backwards compatibility, continue to use version 80 headers for
> short packets before protocol version 100.
>
> From protocol version 100 on, use the same header version for all
> packets.

If I understand it correctly, this patch fixes a backwards compat bug in
code introduced 2 patches earlier:
  [PATCH 08/10] drbd: Introduce protocol version 100 headers

Therefore this patch (and its commit message) should just be rolled into
that one to prevent the bug in the first place.

Cheers,
Kyle Moffett
