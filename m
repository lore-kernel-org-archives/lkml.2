Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636Ab1FFQjI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 12:39:08 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55149 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755375Ab1FFQjF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 12:39:05 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTinqVf+uK+5T_X-EkXw-YE67DJL1Pg@mail.gmail.com>
References: <20110606071829.10334.90865.stgit@ponder> <BANLkTinqVf+uK+5T_X-EkXw-YE67DJL1Pg@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 6 Jun 2011 10:38:44 -0600
X-Google-Sender-Auth: y_NwdYZSzWof06LhYX-3J6ZMk0k
Message-ID: <BANLkTinmfufSkSnmiKWWEgpaR-usbiV5tA@mail.gmail.com>
Subject: Re: [PATCH v2] spi: reorganize drivers
To: Mike Frysinger <vapier.adi@gmail.com>,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 6, 2011 at 10:31 AM, Mike Frysinger <vapier.adi@gmail.com> wrote:
> On Mon, Jun 6, 2011 at 03:18, Grant Likely wrote:
>> Sort the SPI makefile and enforce the naming convention spi_*.c for
>> spi drivers.
>
> spi_topcliff_pch.c uses KBUILD_MODNAME with a few funcs, but perhaps
> those are only for /proc/ status tracking ?  worth double checking ...

I just talked with Dirk Brandewie, who has a major rewrite to the
topcliff spi driver.  I'll let him comment on whether or not changing
KBUILD_MODNAME will cause any problems.

g.
