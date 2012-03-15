Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031561Ab2COBxn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 21:53:43 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:35988 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759659Ab2COBxk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 21:53:40 -0400
MIME-Version: 1.0
In-Reply-To: <20120315105901.7b10c9f4de9374a613436988@canb.auug.org.au>
References: <20120315105901.7b10c9f4de9374a613436988@canb.auug.org.au>
Date: Wed, 14 Mar 2012 21:53:39 -0400
X-Google-Sender-Auth: xLInBUwx9mHPgPz_i1K7c4LfqqA
Message-ID: <CAP=VYLosYNbhGeUYyLr=0xa1UgK=fL-GOafySixFyQjy4GrdgA@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the final tree (arm-soc
 tree related)
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Walle <michael@walle.cc>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 7:59 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> After merging the final tree, today's linux-next build (powerpc
> allmodconfig) failed like this:
>
> drivers/ata/sata_mv.c:4185:1: error: '__mod_of_device_table' aliased to undefined symbol 'mvsdio_dt_ids'
>
> Caused by commit f1e1e148c5cb ("ARM: kirkwood: sata_mv: add device tree
> binding").

Looks like the same thing I reported in yesterday's triage that was
screwing sparc:

http://www.spinics.net/lists/sparclinux/msg09199.html

Odd that it only started screwing powerpc today though.

Paul.
--

> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
