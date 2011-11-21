Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757488Ab1KUWW7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 17:22:59 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53173 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645Ab1KUWW4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 17:22:56 -0500
MIME-Version: 1.0
In-Reply-To: <201111212249.31196.rjw@sisk.pl>
References: <lx6sezwGldO.A.IhF.UBpWOB@chimera> <201111212249.31196.rjw@sisk.pl>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 21 Nov 2011 14:22:33 -0800
X-Google-Sender-Auth: SMF-GalY8-_sSQVvVxGzDlr6Rac
Message-ID: <CA+55aFyy19VYSdZW0+jNxAb8ix0xpX2j9YFw9oQi3jm3+mDEvw@mail.gmail.com>
Subject: Re: 3.2-rc2+: Reported regressions from 3.0 and 3.1
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 1:49 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> Subject    : [3.1-rc8 REGRESSION] sky2 hangs machine on turning off or suspending
> Submitter  : Rafa³ Mi³ecki <zajec5@gmail.com>
> Date       : 2011-11-09 11:46
> Message-ID : CACna6ryTdLcWVYgHu=_mRFga1sFivpE_DyZOY-HMmKggkWAJAw@mail.gmail.com
> References : http://marc.info/?l=linux-netdev&m=132083922228088&w=4

This should be fixed by commit 1401a8008a09 ("sky2: fix hang on
shutdown (and other irq issues)") in current -git.

                   Linus
