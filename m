Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625Ab0FCPzl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 11:55:41 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:48707 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab0FCPzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 11:55:39 -0400
Date: Thu, 3 Jun 2010 08:55:01 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-wireless@vger.kernel.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for June 3 (iwlwifi)
Message-Id: <20100603085501.ac113779.randy.dunlap@oracle.com>
In-Reply-To: <20100603134753.710a64b3.sfr@canb.auug.org.au>
References: <20100603134753.710a64b3.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090207.4C07D077.0021:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jun 2010 13:47:53 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20100602:


when CONFIG_IWLAGN=n:

drivers/net/wireless/iwlwifi/iwl-rx.c:254: error: 'struct iwl_priv' has no member named '_agn'
drivers/net/wireless/iwlwifi/iwl-rx.c:303: error: 'struct iwl_priv' has no member named '_agn'
drivers/net/wireless/iwlwifi/iwl-rx.c:304: error: 'struct iwl_priv' has no member named '_agn'
drivers/net/wireless/iwlwifi/iwl-rx.c:305: error: 'struct iwl_priv' has no member named '_agn'
drivers/net/wireless/iwlwifi/iwl-rx.c:306: error: 'struct iwl_priv' has no member named '_agn'

and many more.

Haven't we seen this movie before?

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
