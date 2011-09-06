Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769Ab1IFTam (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 15:30:42 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58630 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754656Ab1IFTaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 15:30:22 -0400
Message-ID: <4E6674CA.6020405@pobox.com>
Date: Tue, 06 Sep 2011 15:30:18 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Dan McGee <dpmcgee@gmail.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] pata_sis: add mode_filter method for certain sis5513
 chipsets
References: <1315336919-2737-1-git-send-email-dpmcgee@gmail.com> <1315336919-2737-2-git-send-email-dpmcgee@gmail.com>
In-Reply-To: <1315336919-2737-2-git-send-email-dpmcgee@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2011 03:21 PM, Dan McGee wrote:
> This mirrors a very old commit (3160d5416f39da9d9) to the old sis5513
> IDE driver that prevents certain setups from working. UDMA6, aka
> ATA/133, is not supported on some chipsets and we need to ensure this
> mode is not chosen even if a connected drive supports it. Port this old
> patch forward to the new PATA driver to ensure UDMA5 is the highest mode
> used if that is what is supported.
>
> Kernel bugzilla #41582.
>
> Reviewed-by: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> Signed-off-by: Dan McGee<dpmcgee@gmail.com>
> ---
>   drivers/ata/pata_sis.c |   27 ++++++++++++++++++++++++++-
>   1 files changed, 26 insertions(+), 1 deletions(-)


Queued, thanks...




