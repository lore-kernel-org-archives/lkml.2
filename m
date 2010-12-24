Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078Ab0LXJog (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 04:44:36 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:60570 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab0LXJoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 04:44:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=dAO7ct11FZ2vPCERKcFsxKGXN6Ccou/PgE88P5ABQv07N3h2xxosUNq/Vsnp7kz0SK
         YkKbKrVHRWBGH8UtYDXQ8V8j5PY6O1XkJFk/DKrxKrGJE4msq7A1HmikwqNTwGGgegqc
         7DMOmOADY5VkYYmiH1s8WbGIZxy7wEhY+fWZ8=
MIME-Version: 1.0
In-Reply-To: <1293028561-22125-1-git-send-email-anoop.pa@gmail.com>
References: <1292929580-5829-1-git-send-email-anoop.pa@gmail.com>
	<1293028561-22125-1-git-send-email-anoop.pa@gmail.com>
Date: Fri, 24 Dec 2010 03:44:31 -0600
Message-ID: <AANLkTimu_gzsd3NY+HDp7jV+EMtrHGZq7qNc3OedyT3C@mail.gmail.com>
Subject: Re: [PATCH V2 1/2] EHCI support for on-chip PMC MSP USB controller.
From: Shane McDonald <mcdonald.shane@gmail.com>
To: "Anoop P.A" <anoop.pa@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        Anatolij Gustschin <agust@denx.de>, Anand Gadiyar <gadiyar@ti.com>,
        Alan Stern <stern@rowland.harvard.edu>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anoop:

On Wed, Dec 22, 2010 at 8:36 AM, Anoop P.A <anoop.pa@gmail.com> wrote:
> From: Anoop P A <anoop.pa@gmail.com>
>
> This patch includes.
>
> 1. USB host driver for MSP71xx family SoC on-chip USB controller.
> 2. Platform support for USB controller.
>
> Signed-off-by: Anoop P A <anoop.pa@gmail.com>

I tried to apply this patch to a pristine linux-mips.org 2.6.37-rc6 kernel,
but the patch failed on arch/mips/pmc-sierra/msp71xx/Makefile.
I think you must have applied an SMP patch to your tree before
generating this patch.  That was easy to fix, and once I did that,
I tried testing this on a PMC-Sierra MSP7120 Garibaldi evaluation
board.  Using your original changes to drivers/usb/core/hub.c in
addition to this patch, I was able to boot a system, plug a USB hard
drive in, and that drive was recognized by the Garibaldi.

You can add my:

Tested-by: Shane McDonald <mcdonald.shane@gmail.com>
