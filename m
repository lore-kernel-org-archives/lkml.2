Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab2IIJzT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 05:55:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:56321 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753322Ab2IIJzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 05:55:00 -0400
Message-ID: <504C675D.1070505@kernel.dk>
Date: Sun, 09 Sep 2012 11:54:37 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Asai Thambi S P <asamymuthupa@micron.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sam Bradshaw <sbradshaw@micron.com>,
        "Selvan Mani (smani) [CONT - Type 2]" <smani@micron.com>
Subject: Re: [PATCH 0/6] mtip32xx: Support for new devices and minor changes
References: <50477E0E.2070002@micron.com>
In-Reply-To: <50477E0E.2070002@micron.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-09-05 18:30, Asai Thambi S P wrote:
> This patchset adds support for new devices and few minor changes.
> 
> Asai Thambi S P (6):
>   mtip32xx: Add support for new devices
>   mtip32xx: Handle NCQ commands during the security locked state
>   mtip32xx: Increase timeout for standby command
>   mtip32xx: Proper reporting of write protect status on big-endian
>   mtip32xx: Change printk to pr_xxxx
>   mtip32xx: Remove dead code

Thanks, applied for 3.7.

-- 
Jens Axboe

