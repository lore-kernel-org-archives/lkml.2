Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777Ab1JMRdo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 13:33:44 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:48567 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417Ab1JMRdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 13:33:43 -0400
Date: Thu, 13 Oct 2011 13:33:39 -0400 (EDT)
Message-Id: <20111013.133339.2160456691749691633.davem@davemloft.net>
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] piix: add new short cable IDs
From: David Miller <davem@davemloft.net>
In-Reply-To: <201110131520.15650.bzolnier@gmail.com>
References: <201110131520.15650.bzolnier@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 13 Oct 2011 10:33:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Thu, 13 Oct 2011 15:20:15 +0200

> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] piix: add new short cable IDs
> 
> Based on commits 6034734 ("ata_piix: Add new laptop short
> cable IDs") and 760cdb7 ("ata_piix: Add new short cable ID")
> for ata_piix.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

I'm not applying this, users on hardware that IDE doesn't support
currently should use the ATA layer.
