Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896Ab2EaGqY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 02:46:24 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37086 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab2EaGqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 02:46:23 -0400
Message-ID: <4FC71388.40601@kernel.dk>
Date: Thu, 31 May 2012 08:45:28 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Asai Thambi S P <asamymuthupa@micron.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sam Bradshaw <sbradshaw@micron.com>
Subject: Re: [PATCH 00/11] mtip32xx: Number of small tweaks and a new sysfs
 entry
References: <4FC57A61.5050607@micron.com>
In-Reply-To: <4FC57A61.5050607@micron.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2012 03:39 AM, Asai Thambi S P wrote:
> This patchset includes number of small tweaks and adds a new sysfs entry 'flags'
> 
> Asai Thambi S P (11):
>   mtip32xx: fix clearing an incorrect register in mtip_init_port
>   mtip32xx: Set custom timeouts for PIO commands
>   mtip32xx: Change HDIO_GET_IDENTITY to return stored data
>   mtip32xx: Fix to handle TFE for PIO(IOCTL/internal) commands
>   mtip32xx: Set block queue boundary variables
>   mtip32xx: Use plain spinlock for 'cmd_issue_lock'
>   mtip32xx: Fix to support more than one sector in exec_drive_command()
>   mtip32xx: minor performance tweak
>   mtip32xx: Convert macro definitions for flag bits to enum
>   mtip32xx: Changes to sysfs entries
>   mtip32xx: Change disk capacity unit from MB to MiB

Looks fine, only real issue was with 5/5. I've fixed up that patch and
applied all 11, thanks.

-- 
Jens Axboe

