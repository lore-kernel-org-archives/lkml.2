Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458Ab0GIPnt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 11:43:49 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:46946 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756973Ab0GIPnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 11:43:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=jL7QUhK7gdwwJwlMRW6MMuxge3p+b9RzIJGVikdZJMlp5ehU+UViqfu6m0ehKp7/al
         GleklLHEJ6/A4EH59QDtZgFUAovi9mBBgx6djAD6+e/dHL1bn+VbKjw6/wNh1jZgPJJ0
         bvgGGRjeNPqdPDAcaf0sja90HuVQWign6TzRQ=
MIME-Version: 1.0
In-Reply-To: <1278662607.16528.8.camel@eight.analog.com>
References: <1278662607.16528.8.camel@eight.analog.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 9 Jul 2010 11:43:25 -0400
Message-ID: <AANLkTimy9Y7udFmHiR2mSwVFXyenb08hFF6jRWxlntuq@mail.gmail.com>
Subject: Re: [Uclinux-dist-devel] [PATCH] MMC:mmc_spi: Recover from CRC error 
	for SD read/write operation over SPI.
To: sonic zhang <sonic.adi@gmail.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       uclinux-dist-devel <uclinux-dist-devel@blackfin.uclinux.org>,
       linux-mmc@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 9, 2010 at 04:03, sonic zhang <sonic.adi@gmail.com> wrote:
> SPI bus is not reliable on all platforms when doing large dada transfer.

dada -> data

> occational CRC error is reported by SD device. This patch makes the

occational -> occasional
-mike
