Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932506Ab2KVUqm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:46:42 -0500
Received: from manchmal.in-ulm.de ([217.10.9.201]:48904 "EHLO
	manchmal.in-ulm.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932390Ab2KVUqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 15:46:40 -0500
X-Greylist: delayed 387 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Nov 2012 15:46:39 EST
Date: Thu, 22 Nov 2012 21:40:09 +0100
From: Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [ 81/83] ACPI video: Ignore errors after _DOD evaluation.
Message-ID: <1353616368@msgid.manchmal.in-ulm.de>
References: <20121122004212.371862690@linuxfoundation.org>
 <20121122004221.293493645@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121122004221.293493645@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Kroah-Hartman wrote...

> 3.6-stable review patch.  If anyone has any objections, please let me know.

Only a small set of the (guessed) 300 e-mails arrived here, they were:

 - 21/11 Greg Kroah-Hartman   ┬─>[ 81/83] ACPI video: Ignore errors after _DOD evaluation.
 - 21/11 Greg Kroah-Hartman   └─>[ 29/83] ASoC: core: Double control update err for snd_soc_put_volsw_sx
 - 21/11 Greg Kroah-Hartman   [ 05/38] ptp: update adjfreq callback description
 - 21/11 Greg Kroah-Hartman   ┬─>[ 105/171] libceph: fully initialize connection in con_init()
 - 21/11 Greg Kroah-Hartman   ├─>[ 001/171] mm: bugfix: set current->reclaim_state to NULL while returning from kswapd()
 - 21/11 Greg Kroah-Hartman   ├─>[ 075/171] ceph: ensure auth ops are defined before use
 - 21/11 Greg Kroah-Hartman   ├─>[ 086/171] libceph: flush msgr queue during mon_client shutdown
 - 21/11 Greg Kroah-Hartman   ├─>[ 005/171] mac80211: call skb_dequeue/ieee80211_free_txskb instead of __skb_queue_purge
 - 21/11 Greg Kroah-Hartman   ├─>[ 065/171] libceph: dont reset kvec in prepare_write_banner()
 - 21/11 Greg Kroah-Hartman   ├─>[ 049/171] drm/i915: fix overlay on i830M
 - 21/11 Greg Kroah-Hartman   └─>[ 039/171] r8169: Fix WoL on RTL8168d/8111d.


And they had a huge delay of eight hours at kernel.org:

| Received: from mail.kernel.org ([198.145.19.201]:49019 "EHLO mail.kernel.org"
|         rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
|         id S1753592Ab2KVSdp (ORCPT <rfc822;stable@vger.kernel.org>);
|         Thu, 22 Nov 2012 13:33:45 -0500
| Received: from mail.kernel.org (localhost [127.0.0.1])
|         by mail.kernel.org (Postfix) with ESMTP id 87EA220434;
|         Thu, 22 Nov 2012 00:46:51 +0000 (UTC)

Since there was nothing else in the two hours since then, care to
check what went wrong?

Nevertheless, thanks to the predictable patch download URLs, I could
start my tests, everything looks good so far.

    Christoph
