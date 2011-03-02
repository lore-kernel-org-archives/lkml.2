Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab1CBPjY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 10:39:24 -0500
Received: from mms1.broadcom.com ([216.31.210.17]:2469 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959Ab1CBPjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 10:39:22 -0500
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
To: "Greg KH" <greg@kroah.com>, "Stephen Rothwell" <sfr@canb.auug.org.au>
cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Johannes Berg" <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "Roland Vossen" <rvossen@broadcom.com>
Subject: Re: linux-next: manual merge of the staging tree with the
 wireless tree
References: <20110302172754.412dca34.sfr@canb.auug.org.au>
Date: Wed, 2 Mar 2011 16:39:04 +0100
MIME-Version: 1.0
From: "Arend van Spriel" <arend@broadcom.com>
Organization: Broadcom
Message-ID: <op.vrp23ens3ri7v4@arend-laptop>
In-Reply-To: <20110302172754.412dca34.sfr@canb.auug.org.au>
User-Agent: Opera Mail/11.01 (Linux)
X-WSS-ID: 6170BAA368G292617-01-01
Content-Type: text/plain;
 charset=utf-8;
 format=flowed;
 delsp=yes
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 Mar 2011 07:27:54 +0100, Stephen Rothwell  
<sfr@canb.auug.org.au> wrote:

> Hi Greg,
>
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/brcm80211/brcmsmac/wl_mac80211.c between commit
> 7bb4568372856688bc070917265bce0b88bb7d4d ("mac80211: make tx() operation
> return void") from the wireless tree (where this file is called
> drivers/staging/brcm80211/sys/wl_mac80211.c) and commits
> 62b54dca17ef40116491b0ca27ca35fbe9daedc6 ("staging: brcm80211: cleanup
> function prototypes in header files") and
> 55182a10063c40eda4dc5afecff712e5c3617ffc ("staging: brcm80211: cosmetic
> changes") from the staging tree.
>
> I fixed it up (see below) and can carry the fix as necessary.

I saw functions being removed. Checked the modified wl_ops_tx on  
git.kernel.org and it looks fine to me.

Thanks,
AvS
-- 
"The most merciful thing in the world, I think, is the inability of the  
human
mind to correlate all its contents." - "The Call of Cthulhu"

