Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915Ab2DIGhK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 02:37:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:56378 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab2DIGhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 02:37:08 -0400
Message-ID: <4F828378.9060808@kernel.dk>
Date: Mon, 09 Apr 2012 08:36:40 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Asai Thambi S P <asamymuthupa@micron.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <greg@kroah.com>, Sam Bradshaw <sbradshaw@micron.com>
Subject: Re: [PATCH v2 0/7] mtip32xx: Add support for device status and other
 changes
References: <4F824919.3090600@micron.com>
In-Reply-To: <4F824919.3090600@micron.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-04-09 04:27, Asai Thambi S P wrote:
> 
> This patchset adds support for new sysfs entry 'status' and other
> changes like merging various flag variables, handling of commands.
> This also includes the new ABI file for this driver (Reported-by:
> Greg Kroah-Hartman).
> 
> I have split the couple of patches as suggested by Jens, and
> maintained the order of the patches as in previous version. That is
> the reason for 'misc changes' patch being in the middle.

Thanks, this looks better and it applies fine as well. Applied 1-7.

-- 
Jens Axboe

