Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933462Ab1JaVMy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 17:12:54 -0400
Received: from natasha.panasas.com ([67.152.220.90]:42990 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117Ab1JaVMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 17:12:52 -0400
Message-ID: <4EAF0F34.4070702@panasas.com>
Date: Mon, 31 Oct 2011 14:12:20 -0700
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Philip Blundell <philb@gnu.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: 3c505.c: Does not compile on linus/master  [f362f98]
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doing an "make ARCH=i386 allmodconfig" on  linus/master  [f362f98] gives me the below
compilation breakage.

(Fedora_15_amd64 machine)

It's probably old news but I thought I'll report it as part of my obligation
as a Kernel monkey

Cheers
Boaz
----

/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c: In function ‘send_pcb’:
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c:390:1: error: expected identifier before string constant
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c:390:4: error: expected ‘}’ before ‘.’ token
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c:436:1: error: expected identifier before string constant
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c:435:3: error: expected ‘}’ before ‘.’ token
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c: In function ‘start_receive’:
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c:557:1: error: expected identifier before string constant
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c:557:3: error: expected ‘}’ before ‘.’ token
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c: In function ‘receive_packet’:
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c:629:1: error: expected identifier before string constant
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c:629:3: error: expected ‘}’ before ‘.’ token
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c: In function ‘elp_interrupt’:
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c:667:1: error: expected identifier before string constant
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c:665:5: error: expected ‘}’ before ‘.’ token
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c:689:1: error: expected identifier before string constant
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c:689:6: error: expected ‘}’ before ‘.’ token
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c:724:1: error: expected identifier before string constant
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c:723:8: error: expected ‘}’ before ‘.’ token
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c:729:1: error: expected identifier before string constant
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c:728:9: error: expected ‘}’ before ‘.’ token
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c:736:1: error: expected identifier before string constant
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c:736:8: error: expected ‘}’ before ‘.’ token
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c:746:1: error: expected identifier before string constant
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c:746:7: error: expected ‘}’ before ‘.’ token
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c:756:1: error: expected identifier before string constant
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c:755:7: error: expected ‘}’ before ‘.’ token
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c:766:1: error: expected identifier before string constant
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c:765:7: error: expected ‘}’ before ‘.’ token
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c:776:1: error: expected identifier before string constant
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c:775:7: error: expected ‘}’ before ‘.’ token
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c:792:1: error: expected identifier before string constant
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c:792:7: error: expected ‘}’ before ‘.’ token
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c:800:1: error: expected identifier before string constant
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c:800:7: error: expected ‘}’ before ‘.’ token
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c:821:1: error: expected identifier before string constant
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c:820:6: error: expected ‘}’ before ‘.’ token
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c: In function ‘elp_open’:
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c:854:1: error: expected identifier before string constant
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c:854:3: error: expected ‘}’ before ‘.’ token
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c:916:1: error: expected identifier before string constant
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c:916:3: error: expected ‘}’ before ‘.’ token
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c:940:1: error: expected identifier before string constant
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c:940:3: error: expected ‘}’ before ‘.’ token
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c:962:1: error: expected identifier before string constant
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c:962:3: error: expected ‘}’ before ‘.’ token
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c: In function ‘send_packet’:
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c:992:1: error: expected identifier before string constant
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c:992:4: error: expected ‘}’ before ‘.’ token
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c:1014:1: error: expected identifier before string constant
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c:1014:3: error: expected ‘}’ before ‘.’ token
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c:1040:1: error: expected identifier before string constant
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c:1040:3: error: expected ‘}’ before ‘.’ token
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c: In function ‘elp_timeout’:
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c:1057:1: error: expected identifier before string constant
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c:1057:3: error: expected ‘}’ before ‘.’ token
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c: In function ‘elp_start_xmit’:
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c:1079:1: error: expected identifier before string constant
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c:1079:3: error: expected ‘}’ before ‘.’ token
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c:1088:1: error: expected identifier before string constant
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c:1088:4: error: expected ‘}’ before ‘.’ token
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c:1094:1: error: expected identifier before string constant
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c:1094:3: error: expected ‘}’ before ‘.’ token
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c: In function ‘elp_get_stats’:
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c:1113:1: error: expected identifier before string constant
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c:1113:3: error: expected ‘}’ before ‘.’ token
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c: In function ‘elp_close’:
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c:1175:1: error: expected identifier before string constant
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c:1175:3: error: expected ‘}’ before ‘.’ token
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c: In function ‘elp_set_mc_list’:
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c:1219:1: error: expected identifier before string constant
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c:1219:3: error: expected ‘}’ before ‘.’ token
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c:1253:1: error: expected identifier before string constant
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c:1253:3: error: expected ‘}’ before ‘.’ token
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c: In function ‘elp_sense’:
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c:1289:1: error: expected identifier before string constant
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c:1289:3: error: expected ‘}’ before ‘.’ token
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c: In function ‘elp_autodetect’:
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c:1355:1: error: expected identifier before string constant
/net/ca-quad-11a-boot/samana/bharrosh/git/loo-ct/drivers/net/ethernet/i825xx/3c505.c:1355:3: error: expected ‘}’ before ‘.’ token
