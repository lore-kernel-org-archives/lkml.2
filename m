Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231Ab1ETRyi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 13:54:38 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:30931 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab1ETRyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 13:54:37 -0400
Date: Fri, 20 May 2011 10:54:21 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-wireless@vger.kernel.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        Intel Linux Wireless <ilw@linux.intel.com>
Subject: Re: linux-next: Tree for May 20 (iwlwifi)
Message-Id: <20110520105421.3766ea12.randy.dunlap@oracle.com>
In-Reply-To: <20110520165507.cba539d5.sfr@canb.auug.org.au>
References: <20110520165507.cba539d5.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090209.4DD6AAD8.0010:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 May 2011 16:55:07 +1000 Stephen Rothwell wrote:

> Hi all,


drivers/net/wireless/iwlwifi/iwl-agn-rs.c:351: error: 'struct iwl_lq_sta' has no member named 'dbg_fixed_rate'
drivers/net/wireless/iwlwifi/iwl-agn-rs.c:1076: error: 'struct iwl_lq_sta' has no member named 'dbg_fixed_rate'

when CONFIG_MAC80211_DEBUGFS is not enabled.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
