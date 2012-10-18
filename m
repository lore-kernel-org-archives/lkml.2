Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882Ab2JRTMV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 15:12:21 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:54271 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab2JRTMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 15:12:18 -0400
MIME-Version: 1.0
In-Reply-To: <1349649996-17115-1-git-send-email-festevam@gmail.com>
References: <1349649996-17115-1-git-send-email-festevam@gmail.com>
Date: Thu, 18 Oct 2012 16:12:18 -0300
Message-ID: <CAOMZO5ALzQC8nh_rfPoKZUPcB564tykHb42P_OWPHuFJ_KfUJQ@mail.gmail.com>
Subject: Re: [PATCH] ata: sata_highbank: Fix section mismatch
From: Fabio Estevam <festevam@gmail.com>
To: jgarzik@pobox.com
Cc: rob.herring@calxeda.com, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff,

On Sun, Oct 7, 2012 at 7:46 PM, Fabio Estevam <festevam@gmail.com> wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
>
> Building multi_v7_defconfig leads to the following warning:
>
> WARNING: vmlinux.o(.data+0xf7d8): Section mismatch in reference from the variable ahci_highbank_driver to the function .init.text:ahci_highbank_probe()
> The variable ahci_highbank_driver references
> the function __init ahci_highbank_probe()
> If the reference is valid then annotate the
> variable with __init* or __refdata (see linux/init.h) or name the variable:
> *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console
>
> Fix it by annotating ahci_highbank_probe as __devinit.

Can this be applied, please?

Regards,

Fabio Estevam
