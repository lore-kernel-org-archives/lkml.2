Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677Ab1HaPk0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 11:40:26 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:36264 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756627Ab1HaPkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 11:40:18 -0400
X-Sasl-enc: ae0XbXehnXk6k+YUmnYRb3C7NOmgCP60KfG7EYkX8EcQ 1314805217
Date: Wed, 31 Aug 2011 08:38:18 -0700
From: Greg KH <greg@kroah.com>
To: Vishnupradeep <intermedia.vishnu@gmail.com>
Cc: stable@kernel.org, Jiri Slaby <jirislaby@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [stable] linux-3.0.4 compile error on file
 arch/x86/include/asm/unistd_64.h
Message-ID: <20110831153818.GD8618@kroah.com>
References: <CACk0-C9jZatg+v=7DPJtkp3G1k_eiZbwSPDAgqabMyedmKd9YA@mail.gmail.com>
 <4E5C8EA3.7060304@gmail.com>
 <CACk0-C8E2uaB-Ben5K0e7dzC9RC_WDoXx8mV4B-PN4LPYGs92g@mail.gmail.com>
 <20110830181639.GB24865@kroah.com>
 <CACk0-C-zwNOJOY0t7_vQqVBJR9TzKehv+0GTvHxuDiOtSvV0qA@mail.gmail.com>
 <20110830190629.GA5638@kroah.com>
 <CACk0-C_CKkf=xt6QMLe+=nr2P5mTQThreRann5HFe66M7T+SvA@mail.gmail.com>
 <CACk0-C9guZzZEc29--vc8HZm6iB6-==0uC17_UiDKYdqZUzU5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACk0-C9guZzZEc29--vc8HZm6iB6-==0uC17_UiDKYdqZUzU5g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 31, 2011 at 10:17:45AM +0530, Vishnupradeep wrote:
> compiled without error. but..
> 
> [vishnu@localhost linux-3.0.4]$ sudo make modules_install install
> [sudo] password for vishnu:
>   INSTALL arch/x86/kernel/test_nx.ko
>   INSTALL drivers/scsi/scsi_wait_scan.ko
>   INSTALL net/netfilter/xt_mark.ko
>   DEPMOD  3.0.4-vish
> sh /media/Portable/linux-kernel/tar_packs/redown/linux-3.0.4/arch/x86/boot/install.sh
> 3.0.4-vish arch/x86/boot/bzImage \
> 	System.map "/boot"

Glad your build is working now.

I fail to see any error in the above line.  If you are having problems
building and installing a kernel, please try asking on the kernelnewbies
mailing list after reading the documentation on how to do this properly.

good luck,

greg k-h
