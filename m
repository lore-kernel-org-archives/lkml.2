Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932920Ab2KNPgv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 10:36:51 -0500
Received: from casper.infradead.org ([85.118.1.10]:37065 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754014Ab2KNPgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 10:36:51 -0500
Message-ID: <50A3BA89.8060303@kernel.dk>
Date: Wed, 14 Nov 2012 08:36:41 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Selvan Mani <smani@micron.com>
CC: sbradshaw@micron.com, asamymuthupa@micron.com,
        linux-kernel@vger.kernel.org
Subject: Re: mtip32xx: Fix padding issue
References: <50A397DD.4060207@micron.com> <50A399B3.5060806@micron.com>
In-Reply-To: <50A399B3.5060806@micron.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-11-14 06:16, Selvan Mani wrote:
> Hi Jens,
> 
> Another tiny patch.
> 
> Removed __packed before the struct smart_attr and added __packed at end of 
> the structure to fix padding issue.

Thanks, applied.

-- 
Jens Axboe

