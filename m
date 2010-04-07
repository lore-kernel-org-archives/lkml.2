Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757982Ab0DGXTC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 19:19:02 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40607
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757340Ab0DGXS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 19:18:59 -0400
Date: Wed, 07 Apr 2010 16:19:01 -0700 (PDT)
Message-Id: <20100407.161901.43719176.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, yi.zhu@intel.com
Subject: Re: linux-next: manual merge of the wireless tree with the
 wireless-current tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100407144434.GC3146@tuxdriver.com>
References: <20100407125828.d9f03281.sfr@canb.auug.org.au>
	<20100407144434.GC3146@tuxdriver.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 7 Apr 2010 10:44:34 -0400

> On Wed, Apr 07, 2010 at 12:58:28PM +1000, Stephen Rothwell wrote:
>> Hi John,
>> 
>> Today's linux-next merge of the wireless tree got conflicts in
>> drivers/net/wireless/iwlwifi/iwl-core.c,
>> drivers/net/wireless/iwlwifi/iwl-tx.c and
>> drivers/net/wireless/iwlwifi/iwl-core.h between commit
>> de0f60ea94e132c858caa64a44b2012e1e8580b0 ("iwlwifi: avoid Tx queue memory
>> allocation in interface down") from the wireless-current tree and commit
>> 74bcdb33e99f49ef5202dd2f8109945b4570edc2 ("iwlwifi: move agn only tx
>> functions from iwlcore to iwlagn") from the wireless tree.
>> 
>> The latter moved the code modified by the former.  I couldn't see any
>> easy way to fix this up, so I effectively reverted the change in the
>> wireless-current tree.  Please do the merge fixup, thanks.
> 
> OK, I'll try to negotiate this today.

I think I took care of this when I merged net-2.6 into
net-next-2.6 last night.

