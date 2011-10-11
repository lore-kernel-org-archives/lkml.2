Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422Ab1JKTTz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 15:19:55 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:34307 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755198Ab1JKTTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 15:19:54 -0400
Date: Tue, 11 Oct 2011 15:19:51 -0400 (EDT)
Message-Id: <20111011.151951.1577174625312965764.davem@davemloft.net>
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] piix: ICH7 MWDMA1 errata
From: David Miller <davem@davemloft.net>
In-Reply-To: <201110111924.55510.bzolnier@gmail.com>
References: <201110111924.55510.bzolnier@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 11 Oct 2011 12:19:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Tue, 11 Oct 2011 19:24:55 +0200

> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] piix: ICH7 MWDMA1 errata
> 
> Based on libata commit c611bed7.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Applied.
