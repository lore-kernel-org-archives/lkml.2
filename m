Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254Ab0EEFrG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 01:47:06 -0400
Received: from smtp.nokia.com ([192.100.122.230]:30341 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518Ab0EEFrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 01:47:01 -0400
Subject: Re: [PATCHv3] mtd: cfi_cmdset_0002: Add reboot notifier for AMD
 flashes
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Kevin Cernekee <cernekee@gmail.com>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <471a5dfa1495f2d33e41435e4d37852ad489b112@localhost.localdomain>
References: <1272519262.7750.66.camel@localhost>
	 <471a5dfa1495f2d33e41435e4d37852ad489b112@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 May 2010 08:40:27 +0300
Message-ID: <1273038027.3702.52.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 05 May 2010 05:46:41.0810 (UTC) FILETIME=[567F4F20:01CAEC16]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-29 at 10:26 -0700, Kevin Cernekee wrote:
> Ensure that the flash device is in a quiescent state before rebooting.
> The implementation is closely modeled after the cfi_cmdset_0001 reboot
> notifier, commit 963a6fb0a0d336d0513083b7e4b5c3ff9d6d2061 .
> 
> Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
> ---
>  drivers/mtd/chips/cfi_cmdset_0002.c |   56 +++++++++++++++++++++++++++++++++++
>  1 files changed, 56 insertions(+), 0 deletions(-)

Pushed to l2-mtd-2.6 / master, thanks.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

