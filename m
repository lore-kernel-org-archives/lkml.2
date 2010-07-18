Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522Ab0GRH1d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 03:27:33 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42476 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab0GRH1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 03:27:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=GVcZyiEUEayJ18qIE2hmujipSyQ7CaRN7hpeAoixSIn9kEB1G8xq+Uq//5wPqU4fa0
         KRtvc0whw8YiDtrPzL2b08KRfime+lrJnye3buAVfQ8AKQznT2TGhWaboEcwdshk76f5
         dD80lwDgEYiW1nIPhV3whTpGUbrjxN6LhekQE=
Subject: Re: [PATCH 1/6] Mtd: fixed coding style indent errors
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Neal B <nealb001@gmail.com>
Cc: Artem.Bityutskiy@nokia.com, dwmw2@infradead.org,
        rmk+kernel@arm.linux.org.uk, cascardo@holoscopio.com,
        mohanlaljangir@gmail.com, maximlevitsky@gmail.com,
        Julia Lawall <julia@diku.dk>, jkosina@suse.cz,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <4C3A8220.6040707@gmail.com>
References: <4C3A8220.6040707@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 18 Jul 2010 10:27:26 +0300
Message-Id: <1279438046.16247.22.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-07-11 at 21:46 -0500, Neal B wrote:
> From f4301b9c13f65d173d67759d53acaf3e8d2331c6 Mon Sep 17 00:00:00 2001
> From: Neal Buckendahl <nealb001@gmail.com>
> Date: Sun, 11 Jul 2010 16:58:24 -0500
> Subject: [PATCH 1/6] Mtd: fixed coding style indent errors found by the 
> checkpatch.pl tool
>   Signed-off-by: Neal Buckendahl <nealb001@gmail.com>

Unfortunately, your patches are line-wrapped. You should send
non-wrapped patches. Use git send-email - it can do the trick (use
--dry-run first, check everything is fine, then send).

Also, int the commit message, it is a bit better to specify which
exactly warning it fixes.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

