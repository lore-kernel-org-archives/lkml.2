Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751446Ab1ARMMT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 07:12:19 -0500
Received: from mail-fx0-f66.google.com ([209.85.161.66]:57116 "EHLO
	mail-fx0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab1ARMMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 07:12:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=iNS6brI7icep0O6kcod5ekMXfAEKvaZWIc2SSrb9X7wWbKE1ZJGL5poGXu/YNcvq1j
         AdP6ihwDX0U5GaLnfEHxKjA3LuW2QjApmUDzYSQXpMuOoDyUufRccgDknUEMgVTGg7Oq
         DA3Rwlrpr+yZq0GMi0zJHIeDkSuiPdIKlWowI=
Subject: Re: [PATCH] mtd_blkdevs: local symbols should be static
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <0D753D10438DA54287A00B027084269764CE0E550B@AUSP01VMBX24.collaborationhost.net>
References: <0D753D10438DA54287A00B027084269764CE0E550B@AUSP01VMBX24.collaborationhost.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Jan 2011 14:12:09 +0200
Message-ID: <1295352729.2470.134.camel@koala>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-11 at 18:46 -0600, H Hartley Sweeten wrote:
> The function blktrans_dev_release and blktrans_dev_put are only used
> locally in this file and should be static.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: David Woodhouse <dwmw2@infradead.org>

Pushed to l2-mtd-2.6.git, thanks.

-- 
Best Regards,
Artem Bityutskiy (Битюцкий Артём)

