Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151Ab0H3M6O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 08:58:14 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:37729 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754772Ab0H3M6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 08:58:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=jEarw+KpexwxFxGcnhXCPc74dH7TZ8K7VZdKW4/TOlNmNTo2hX/P5Gl3E51XLDGjv0
         /DOHazXB2T4dnLHhIrBgpIhWmneQC701yCt2WWcdioLfpanKB08tlGFKPMQLyocgATAM
         JFsWH31nyPYKNwxgmb5NPRbwmtGzNRVE1ih58=
Subject: Re: [PATCH] mtd: Blackfin NFC: fix invalid free in remove()
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1283028125-6027-1-git-send-email-vapier@gentoo.org>
References: <1283028125-6027-1-git-send-email-vapier@gentoo.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Aug 2010 15:58:06 +0300
Message-ID: <1283173086.12995.74.camel@brekeke>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-08-28 at 16:42 -0400, Mike Frysinger wrote:
> Since info->mtd isn't dynamically allocated, we shouldn't attempt to
> kfree() it.  Otherwise we get random fun corruption when unloading
> the driver built as a module.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
> note: this should be merged for 2.6.36 and probably sent to stable trees

You send the same patch 2 times once with this note and the other time
without this note. Which one should be ignored?

-- 
Best Regards,
Artem Bityutskiy (Битюцкий Артём)

