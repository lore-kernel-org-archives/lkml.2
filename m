Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459Ab0H3HHc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 03:07:32 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:64721 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330Ab0H3HHa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 03:07:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=FQPbwMZye6kWTDC2pHo+YqkxXaN+GT2IsLnCkZWBVl+/JoiguBAs12gZk8cfD344RR
         AvhCvud9HnEjuL2KrIHNzWdgjwQD8Ud9LCyKZeDIJZIGehdyJBq22ex79DqQHT6CDj6v
         WIvowMB2rPgq8C/8PiHhA+KOOWYidJgwKupUs=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1008300856010.28212@ayla.of.borg>
References: <alpine.DEB.2.00.1008300856010.28212@ayla.of.borg>
Date: Mon, 30 Aug 2010 10:07:30 +0300
X-Google-Sender-Auth: 04-ozSNv0U6Jvyrf5RPM4aXRYac
Message-ID: <AANLkTikj_wiN_PcScrgkfHEoQwEJPQRm6XhsU5CuLby9@mail.gmail.com>
Subject: Re: [PATCH resend v2.6.36-rc3] staging: spectra needs <linux/slab.h>
From: Pekka Enberg <penberg@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/30 Geert Uytterhoeven <geert@linux-m68k.org>:
> On one of my m68k test builds I get:
>
> drivers/staging/spectra/ffsport.c: In function ‘ioctl_read_page_data’:
> drivers/staging/spectra/ffsport.c:196: error: implicit declaration of function ‘kmalloc’
> drivers/staging/spectra/ffsport.c:196: warning: assignment makes pointer from integer without a cast
> drivers/staging/spectra/ffsport.c:212: error: implicit declaration of function ‘kfree’
> drivers/staging/spectra/ffsport.c: In function ‘ioctl_write_page_data’:
> drivers/staging/spectra/ffsport.c:229: warning: assignment makes pointer from integer without a cast
> drivers/staging/spectra/ffsport.c: In function ‘SBD_setup_device’:
> drivers/staging/spectra/ffsport.c:637: warning: assignment makes pointer from integer without a cast
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Acked-by: Pekka Enberg <penberg@kernel.org>
