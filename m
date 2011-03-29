Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756Ab1C2AsB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 20:48:01 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:63917 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab1C2Ar7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 20:47:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DO0nx+UbZx5qyZS84yH4rwUIjXlf8K3B6xwQMGMEg9mlJH2MLLRtueFfcY+Kanyt0+
         Ww6OSFZSXjpNtNy1igPZWky/fOjW4D50xQaEHmR8vCKhHIgzBfDqVnmzV6+FHPSeYDmp
         iQZm/sdkBBv6bVhdb1BqM9/RFXZ98PvXl+yHM=
MIME-Version: 1.0
In-Reply-To: <20110328172230.01756522@queued.net>
References: <20110328172230.01756522@queued.net>
Date: Mon, 28 Mar 2011 21:47:58 -0300
Message-ID: <AANLkTikLK+jbVhnrNVinhLDXZoozH-6VsjwjYLNwTdxU@mail.gmail.com>
Subject: Re: [PATCH resend] ARM: mx51_efika: fix build error due to new mfd changes
From: Fabio Estevam <festevam@gmail.com>
To: Andres Salomon <dilinger@queued.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Amit Kucheria <amit.kucheria@canonical.com>,
        Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andres,

On Mon, Mar 28, 2011 at 9:22 PM, Andres Salomon <dilinger@queued.net> wrote:
>
> MFD changes in 4ec1b54c ('mfd: mfd_cell is now implicitly available
> to mc13xxx drivers') changed the mc13xxx_platform_data struct layout.
> At the time all users were changed, but this driver was introduced in
> another tree at the same time.  This updates the mc13xxx_platform_data
> user, fixing a build error.
>
> Signed-off-by: Andres Salomon <dilinger@queued.net>
> ---
>  arch/arm/mach-mx5/mx51_efika.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)

Your patch is in Sascha´s tree now:
http://git.pengutronix.de/?p=imx/linux-2.6.git;a=commitdiff;h=251290a6078cb88382344b3ee535ae8c6254c1b5

Regards,

Fabio Estevam
