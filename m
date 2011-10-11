Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378Ab1JKTRp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 15:17:45 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:34289 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755198Ab1JKTRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 15:17:43 -0400
Date: Tue, 11 Oct 2011 15:17:39 -0400 (EDT)
Message-Id: <20111011.151739.917285592017305911.davem@davemloft.net>
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ide: ide_port_wait_ready() fix
From: David Miller <davem@davemloft.net>
In-Reply-To: <201110111913.18492.bzolnier@gmail.com>
References: <201110111913.18492.bzolnier@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 11 Oct 2011 12:17:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Tue, 11 Oct 2011 19:13:18 +0200

> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] ide: ide_port_wait_ready() fix
> 
> Fix for commit a20b2a4 ("ide: skip probe if there are no devices on
> the port (v2)").  We must check for slave device before failing.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

This will mishandle the case where there is no slave in the device
list.
