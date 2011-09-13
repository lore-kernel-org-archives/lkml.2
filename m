Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973Ab1IMHzd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 03:55:33 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45920 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685Ab1IMHzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 03:55:31 -0400
MIME-Version: 1.0
In-Reply-To: <1315899939.3402.2.camel@snb>
References: <1315899939.3402.2.camel@snb>
Date: Tue, 13 Sep 2011 15:55:31 +0800
Message-ID: <CAM_iQpVsKXn3ZMygOKc699KQPXbt=-yEWMdKFLqYGVucoJ874w@mail.gmail.com>
Subject: Re: [PATCH -v2] netconsole: switch init_netconsole() to late_initcall
 if build-in
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 13, 2011 at 3:45 PM, Lin Ming <ming.m.lin@intel.com> wrote:
> Commit 88491d8(drivers/net: Kconfig & Makefile cleanup) causes a
> regression that netconsole does not work if netconsole and network
> device driver are build into kernel, because netconsole is linked
> before network device driver.
>
> Andrew Morton suggested to fix this with initcall ordering.
> Fixes it by switching init_netconsole() to late_initcall if build-in.
>

Putting one or two lines of comments into the code would
be nicer, otherwise people have to dig git log to see why. ;-)

Thanks!
