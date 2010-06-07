Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573Ab0FGQDX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 12:03:23 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:21143 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273Ab0FGQDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 12:03:21 -0400
Date: Mon, 7 Jun 2010 09:02:30 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-wireless@vger.kernel.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for June 7 (iwlwifi)
Message-Id: <20100607090230.deed8bd1.randy.dunlap@oracle.com>
In-Reply-To: <20100607142034.c96c2509.sfr@canb.auug.org.au>
References: <20100607142034.c96c2509.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090208.4C0D1845.01CE:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jun 2010 14:20:34 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20100604:


2 different builds:

drivers/net/wireless/iwlwifi/iwl-rx.c: In function 'iwl_accumulative_statistics':
drivers/net/wireless/iwlwifi/iwl-rx.c:304: error: 'struct iwl_priv' has no member named 'accum_statistics'
drivers/net/wireless/iwlwifi/iwl-rx.c:305: error: 'struct iwl_priv' has no member named 'delta_statistics'
drivers/net/wireless/iwlwifi/iwl-rx.c:306: error: 'struct iwl_priv' has no member named 'max_delta'
drivers/net/wireless/iwlwifi/iwl-rx.c:321: error: 'struct iwl_priv' has no member named 'accum_statistics'
drivers/net/wireless/iwlwifi/iwl-rx.c:323: error: 'struct iwl_priv' has no member named 'accum_statistics'
drivers/net/wireless/iwlwifi/iwl-rx.c:325: error: 'struct iwl_priv' has no member named 'accum_statistics'
drivers/net/wireless/iwlwifi/iwl-rx.c:327: error: 'struct iwl_priv' has no member named 'accum_statistics'
drivers/net/wireless/iwlwifi/iwl-rx.c:329: error: 'struct iwl_priv' has no member named 'accum_statistics'
drivers/net/wireless/iwlwifi/iwl-rx.c:331: error: 'struct iwl_priv' has no member named 'accum_statistics'
drivers/net/wireless/iwlwifi/iwl-rx.c: In function 'iwl_reply_statistics':
drivers/net/wireless/iwlwifi/iwl-rx.c:484: error: 'struct iwl_priv' has no member named 'accum_statistics'
drivers/net/wireless/iwlwifi/iwl-rx.c:486: error: 'struct iwl_priv' has no member named 'delta_statistics'
drivers/net/wireless/iwlwifi/iwl-rx.c:488: error: 'struct iwl_priv' has no member named 'max_delta'


--and--

drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c: In function 'iwl_ucode_rx_stats_read':
drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c:86: error: 'struct iwl_priv' has no member named 'accum_statistics'
drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c:87: error: 'struct iwl_priv' has no member named 'accum_statistics'
drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c:88: error: 'struct iwl_priv' has no member named 'accum_statistics'
drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c:89: error: 'struct iwl_priv' has no member named 'accum_statistics'
drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c:90: error: 'struct iwl_priv' has no member named 'delta_statistics'
drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c:91: error: 'struct iwl_priv' has no member named 'delta_statistics'
drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c:92: error: 'struct iwl_priv' has no member named 'delta_statistics'
drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c:93: error: 'struct iwl_priv' has no member named 'delta_statistics'
drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c:94: error: 'struct iwl_priv' has no member named 'max_delta'
drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c:95: error: 'struct iwl_priv' has no member named 'max_delta'
drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c:96: error: 'struct iwl_priv' has no member named 'max_delta'
drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c:97: error: 'struct iwl_priv' has no member named 'max_delta'
drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c: In function 'iwl_ucode_tx_stats_read':
drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c:564: error: 'struct iwl_priv' has no member named 'accum_statistics'
drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c:565: error: 'struct iwl_priv' has no member named 'delta_statistics'
drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c:566: error: 'struct iwl_priv' has no member named 'max_delta'
drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c: In function 'iwl_ucode_general_stats_read':
drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c:783: error: 'struct iwl_priv' has no member named 'accum_statistics'
drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c:784: error: 'struct iwl_priv' has no member named 'delta_statistics'
drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c:785: error: 'struct iwl_priv' has no member named 'max_delta'
drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c:786: error: 'struct iwl_priv' has no member named 'accum_statistics'
drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c:787: error: 'struct iwl_priv' has no member named 'delta_statistics'
drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c:788: error: 'struct iwl_priv' has no member named 'max_delta'
drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c:789: error: 'struct iwl_priv' has no member named 'accum_statistics'
drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c:790: error: 'struct iwl_priv' has no member named 'delta_statistics'
drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c:791: error: 'struct iwl_priv' has no member named 'max_delta'


config files available if needed.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
