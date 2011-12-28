Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524Ab1L1VHD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 16:07:03 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:38049 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754311Ab1L1VG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 16:06:58 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:1aa9:5ff:fe24:37a9]
In-Reply-To: <1325076512.6997.1.camel@phoenix>
References: <1325076512.6997.1.camel@phoenix>
Date: Wed, 28 Dec 2011 13:06:58 -0800
Message-ID: <CAOesGMhtu0r4q8fTuG=zjQKPUG2qx48MOz-MRnymYTAf_=QGCQ@mail.gmail.com>
Subject: Re: [PATCH RESEND] i2c: Convert to DEFINE_PCI_DEVICE_TABLE
From: Olof Johansson <olof@lixom.net>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Rudolf Marek <r.marek@assembler.cz>,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        "Mark M. Hoffman" <mhoffman@lightlink.com>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>,
        Wolfram Sang <w.sang@pengutronix.de>, Feng Tang <feng.tang@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-i2c@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 28, 2011 at 4:48 AM, Axel Lin <axel.lin@gmail.com> wrote:
> Convert static struct pci_device_id *[] to static DEFINE_PCI_DEVICE_TABLE
> tables.
>
> Use DEFINE_PCI_DEVICE_TABLE ensures we make the pci_device_id table const
> and marked as __devinitconst.
>
> This also fixes some warnings from checkpatch:
> e.g.
> WARNING: Use DEFINE_PCI_DEVICE_TABLE for struct pci_device_id
> #1096: FILE: i2c/busses/i2c-intel-mid.c:1096:
> +static struct pci_device_id intel_mid_i2c_ids[] = {
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> Cc: Rudolf Marek <r.marek@assembler.cz>
> Cc: Jean Delvare <khali@linux-fr.org>
> Cc: Ben Dooks <ben-linux@fluff.org>
> Cc: Olof Johansson <olof@lixom.net>
> Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>
> Cc: Dirk Brandewie <dirk.brandewie@gmail.com>
> Cc: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
> Cc: Wolfram Sang <w.sang@pengutronix.de>
> Cc: Feng Tang <feng.tang@intel.com>
> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Cc: linux-i2c@vger.kernel.org

Acked-by: Olof Johansson <olof@lixom.net> [PA Semi portion]
