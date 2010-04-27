Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838Ab0D0N3o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 09:29:44 -0400
Received: from smtp.nokia.com ([192.100.122.230]:47327 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755789Ab0D0N3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 09:29:42 -0400
Subject: Re: [PATCH 2/2] UBI: Remove reboot notifier
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Kevin Cernekee <cernekee@gmail.com>
Cc: dwmw2@infradead.org, saeed.bishara@gmail.com,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <e5370484641ae54d637ece47f411bb0b0061cc54@localhost.localdomain>
References: <4ccec90e21edfa387822b2cb71c886217c48b4e3@localhost.localdomain>
	 <e5370484641ae54d637ece47f411bb0b0061cc54@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Apr 2010 16:25:15 +0300
Message-ID: <1272374715.7750.8.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 27 Apr 2010 13:29:30.0164 (UTC) FILETIME=[AA6BDF40:01CAE60D]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-13 at 13:30 -0700, Kevin Cernekee wrote:
> The UBI reboot notifier causes problems with hibernation.  Move this
> functionality into the low-level MTD driver instead.
> 
> Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
> ---
>  drivers/mtd/ubi/build.c |   35 -----------------------------------
>  drivers/mtd/ubi/ubi.h   |    2 --
>  2 files changed, 0 insertions(+), 37 deletions(-)
> 

Pushed this patch to the ubi-2.6.git tree, thanks.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

