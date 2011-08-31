Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598Ab1HaEsK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 00:48:10 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:39658 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931Ab1HaEsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 00:48:06 -0400
MIME-Version: 1.0
In-Reply-To: <CACk0-C_CKkf=xt6QMLe+=nr2P5mTQThreRann5HFe66M7T+SvA@mail.gmail.com>
References: <CACk0-C9jZatg+v=7DPJtkp3G1k_eiZbwSPDAgqabMyedmKd9YA@mail.gmail.com>
 <4E5C8EA3.7060304@gmail.com> <CACk0-C8E2uaB-Ben5K0e7dzC9RC_WDoXx8mV4B-PN4LPYGs92g@mail.gmail.com>
 <20110830181639.GB24865@kroah.com> <CACk0-C-zwNOJOY0t7_vQqVBJR9TzKehv+0GTvHxuDiOtSvV0qA@mail.gmail.com>
 <20110830190629.GA5638@kroah.com> <CACk0-C_CKkf=xt6QMLe+=nr2P5mTQThreRann5HFe66M7T+SvA@mail.gmail.com>
From: Vishnupradeep <intermedia.vishnu@gmail.com>
Date: Wed, 31 Aug 2011 10:17:45 +0530
Message-ID: <CACk0-C9guZzZEc29--vc8HZm6iB6-==0uC17_UiDKYdqZUzU5g@mail.gmail.com>
Subject: Re: [stable] linux-3.0.4 compile error on file arch/x86/include/asm/unistd_64.h
To: Greg KH <greg@kroah.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org,
        stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

compiled without error. but..

[vishnu@localhost linux-3.0.4]$ sudo make modules_install install
[sudo] password for vishnu:
  INSTALL arch/x86/kernel/test_nx.ko
  INSTALL drivers/scsi/scsi_wait_scan.ko
  INSTALL net/netfilter/xt_mark.ko
  DEPMOD  3.0.4-vish
sh /media/Portable/linux-kernel/tar_packs/redown/linux-3.0.4/arch/x86/boot/install.sh
3.0.4-vish arch/x86/boot/bzImage \
	System.map "/boot"
