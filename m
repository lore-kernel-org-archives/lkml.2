Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757698Ab2INRFh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 13:05:37 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:37027 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753344Ab2INRFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 13:05:34 -0400
Message-ID: <505363BA.1010604@xenotime.net>
Date: Fri, 14 Sep 2012 10:04:58 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-ide@vger.kernel.org, Mark Langsdorf <mark.langsdorf@calxeda.com>
Subject: Re: linux-next: Tree for Sept 14 (sata_highhbank)
References: <20120914173813.fa65528e5236bd0a20c29b92@canb.auug.org.au>
In-Reply-To: <20120914173813.fa65528e5236bd0a20c29b92@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/2012 12:38 AM, Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 201209013:
> 



on i386:

CONFIG_SATA_HIGHBANK=m
# CONFIG_SATA_AHCI_PLATFORM is not set

ERROR: "ahci_sdev_attrs" [drivers/ata/sata_highbank.ko] undefined!
ERROR: "ahci_shost_attrs" [drivers/ata/sata_highbank.ko] undefined!
ERROR: "ahci_ops" [drivers/ata/sata_highbank.ko] undefined!
ERROR: "ahci_dev_classify" [drivers/ata/sata_highbank.ko] undefined!
ERROR: "ahci_start_engine" [drivers/ata/sata_highbank.ko] undefined!
ERROR: "ahci_stop_engine" [drivers/ata/sata_highbank.ko] undefined!
ERROR: "ahci_interrupt" [drivers/ata/sata_highbank.ko] undefined!
ERROR: "ahci_print_info" [drivers/ata/sata_highbank.ko] undefined!
ERROR: "ahci_reset_em" [drivers/ata/sata_highbank.ko] undefined!
ERROR: "ahci_ignore_sss" [drivers/ata/sata_highbank.ko] undefined!
ERROR: "ahci_set_em_messages" [drivers/ata/sata_highbank.ko] undefined!
ERROR: "ahci_save_initial_config" [drivers/ata/sata_highbank.ko] undefined!
ERROR: "ahci_init_controller" [drivers/ata/sata_highbank.ko] undefined!
ERROR: "ahci_reset_controller" [drivers/ata/sata_highbank.ko] undefined!

-- 
~Randy
