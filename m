Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab1EIHCK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 03:02:10 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50231 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab1EIHCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 03:02:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=J6Xa/tmWEfIENhytca9rYfApyCOHi33dw4lTW9QCL2y2+scJ1e1eBpPGULnU7hnh0r
         1rMZsS6+UKdbDsP88LiITC6Q7pbTUpQ6wxxuygYXiYTtwTGH5PH7MZLHORcYgkoHEPuU
         zToS7FC36HxVeW5ferO0hlJ+GAUliceMhe+0A=
MIME-Version: 1.0
In-Reply-To: <1304901131-7104-4-git-send-email-sameo@linux.intel.com>
References: <1304901131-7104-1-git-send-email-sameo@linux.intel.com>
	<1304901131-7104-4-git-send-email-sameo@linux.intel.com>
Date: Mon, 9 May 2011 09:02:08 +0200
X-Google-Sender-Auth: pLNccJb4Xv7SLh-QralnmX7iqtA
Message-ID: <BANLkTi=6m-sb=vz63YxOWZZXho8GupD=sg@mail.gmail.com>
Subject: Re: [PATCH 03/19] mfd: Use mfd cell platform_data for ab3100 cells
 platform bits
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/9 Samuel Ortiz <sameo@linux.intel.com>:

> With the addition of a platform device mfd_cell pointer, MFD drivers
> can go back to passing platform data back to their sub drivers.
> This allows for an mfd_cell->mfd_data removal and thus keep the sub drivers
> MFD agnostic. This is mostly needed for non MFD aware sub drivers.
>
> Cc: Linus Walleij <linus.walleij@stericsson.com>
> Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks,
Linus Walleij
