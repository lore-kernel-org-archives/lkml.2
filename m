Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672Ab2DEOKF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 10:10:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:46776 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740Ab2DEOKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 10:10:04 -0400
Message-ID: <4F7DA7AE.2010006@kernel.dk>
Date: Thu, 05 Apr 2012 08:09:50 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Ryosuke Saito <raitosyo@gmail.com>
CC: asamymuthupa@micron.com, sbradshaw@micron.com, dan.carpenter@oracle.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mtip32xx: fix error handling in mtip_init()
References: <1333623351.3193.10.camel@HDL00099>
In-Reply-To: <1333623351.3193.10.camel@HDL00099>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-04-05 04:55, Ryosuke Saito wrote:
> Sweep registered blkdev when pci_register_driver has failed.

Thanks, applied.

-- 
Jens Axboe

