Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784Ab2DRTeM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 15:34:12 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:33766 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156Ab2DRTeK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 15:34:10 -0400
MIME-Version: 1.0
In-Reply-To: <20120418184624.GA16313@havoc.gtf.org>
References: <20120418184624.GA16313@havoc.gtf.org>
Date: Wed, 18 Apr 2012 15:34:09 -0400
Message-ID: <CA+5PVA7zv2H-CQU3Grouk3KH5xA3XLijuO7TPX9zrMdj-7z43Q@mail.gmail.com>
Subject: Re: [git patches] libata fixes
From: Josh Boyer <jwboyer@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 2:46 PM, Jeff Garzik <jeff@garzik.org> wrote:
>
> NOTE: Includes important regression fix.  See signed tag message for more.
>
> Please pull 0c8d32c27f5cf6e14ca14b4758d1e994eebd50fd from
> git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git tag/upstream-linus
>
>
> to receive the following updates:
>
>  drivers/ata/ata_piix.c         |    2 ++
>  drivers/ata/libata-core.c      |    4 ++--
>  drivers/ata/libata-scsi.c      |    4 ++--
>  drivers/ata/libata-transport.c |    1 +
>  drivers/ata/libata.h           |    2 +-
>  drivers/ata/sata_mv.c          |    3 ++-
>  6 files changed, 10 insertions(+), 6 deletions(-)
>
> Dan Carpenter (1):
>      sata_mv: silence an uninitialized variable warning
>
> Dan Williams (1):
>      libata: make ata_print_id atomic
>
> Lin Ming (1):
>      libata: forbid port runtime pm by default, fixing regression

I noticed that this regression fix doesn't have the
CC: stable@vger.kernel.org tag in it, but it's needed on the 3.3
trees.  Should it be sent to the stable list separately?

josh
