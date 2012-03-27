Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196Ab2C0C0Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 22:26:16 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:54072 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755133Ab2C0C0K convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 22:26:10 -0400
MIME-Version: 1.0
In-Reply-To: <20120327005307.GB26825@windriver.com>
References: <20120327005307.GB26825@windriver.com>
Date: Mon, 26 Mar 2012 22:26:08 -0400
X-Google-Sender-Auth: 75DT4np4mr_0HztH-UVDlJxqt_o
Message-ID: <CAP=VYLrvnD7qWAPbCkf_4RtEgznF-tL=d+z4TaKt1QJ2TWs7AA@mail.gmail.com>
Subject: Re: linux-next: triage for March 26th, 2012
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: linux-next@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 8:53 PM, Paul Gortmaker
<paul.gortmaker@windriver.com> wrote:

> New breakage since last report:
>        ARM:rpc_defconfig (scsi/arm/powertec.c: implicit 'seq_printf')
>        ARM:omap2plus_defconfig (board-omap4panda.c: 'btwilink_device' undecl)
>        m68k:sun3_defconfig,m68k_defconfig (sun3_NCR5380.c: static decl of
>                                 'sun3scsi_proc_info' follows non-static)
>        ia64:defconfig (asm-offsets.c:322: unterm arg list invoking macro "DEFINE")

[...]

> ia64:defconfig
>        when:   Mar 26
>        why:    asm-offsets.c:322: unterminated arg list invoking macro "DEFINE"
>        status:
>        fix:
>        ref:

Cause and trivial fix is here:

          https://lkml.org/lkml/2012/3/26/496

Paul.
