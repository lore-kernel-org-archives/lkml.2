Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577Ab1EIHBM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 03:01:12 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54952 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab1EIHBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 03:01:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=unP0hL+74Wi80Ko0iZpNC6TIyP+nq94jm+zAT3+BcDtcqmnCgOHiVMWHhrGvYcJeBU
         fmwzFISalN0zRByEE3hiMaZLOeBCMODmbKMYU+dHLS4mncKrmGxzI5/zVB3MQCa4djwr
         joWpoKk6uKjOKiWeWE27at4VmHQVAmy2yabfE=
MIME-Version: 1.0
In-Reply-To: <1304901131-7104-3-git-send-email-sameo@linux.intel.com>
References: <1304901131-7104-1-git-send-email-sameo@linux.intel.com>
	<1304901131-7104-3-git-send-email-sameo@linux.intel.com>
Date: Mon, 9 May 2011 09:01:10 +0200
X-Google-Sender-Auth: azAJl9iCaOHbxkWdu7PtiYAo1V4
Message-ID: <BANLkTi=sAFxHbMvnH8BOr-BzZ=uhhx-qaA@mail.gmail.com>
Subject: Re: [PATCH 02/19] mfd: Use mfd cell platform_data for ab3550 cells
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

I was always just puzzled by that stuff anyway...

Thanks,
Linus Walleij
