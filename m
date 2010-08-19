Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072Ab0HSUgY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 16:36:24 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:44023 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341Ab0HSUgW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 16:36:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=N2UUG/ALt6+fOoxyGAx13NCwAyHJ7LRQW+SS0TGWgPmW6Z98zAgJZFqVxYDPmNjE+E
         FI7TxfOkh1ajgcOMbnkR+gk51yFq1/yMPMvp7MjKgb5wPyPb2NDO351iCzm0xWsL0Iqn
         nwEz8ddrAS5VQALjnelBMN/1uxWHipJOzw/bQ=
MIME-Version: 1.0
In-Reply-To: <20100801074831.1099.3318.stgit@angua>
References: <20100801074831.1099.3318.stgit@angua>
Date: Thu, 19 Aug 2010 15:36:21 -0500
X-Google-Sender-Auth: xc4rfO6ir3HOugm7gjuAXLBck_Y
Message-ID: <AANLkTiny_N-UqzuVaftLj75e_b0PjsdHstH8ZKx5mw7O@mail.gmail.com>
Subject: Re: [PATCH] of/device: Replace struct of_device with struct of_platform
From: Timur Tabi <timur@freescale.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: sfr@canb.auug.org.au, monstr@monstr.eu, microblaze-uclinux@itee.uq.edu.au,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, benh@kernel.crashing.org,
        sparclinux@vger.kernel.org, davem@davemloft.net,
        alsa-devel mailing list <alsa-devel@alsa-project.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 1, 2010 at 2:57 AM, Grant Likely <grant.likely@secretlab.ca> wrote:

>  sound/soc/fsl/mpc8610_hpcd.c                  |    4 +-

This file is/was significantly rewritten for 2.6.37.  I posted a fix
to the alsa mailing list, but it will conflict with your patch.  You
might want to remove all changes to sound/soc/fsl from this commit.

-- 
Timur Tabi
Linux kernel developer at Freescale
