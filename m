Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935750Ab1JFI7V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 04:59:21 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:4003 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935622Ab1JFI7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 04:59:19 -0400
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
Message-ID: <4E8D6DDE.9050102@broadcom.com>
Date: Thu, 6 Oct 2011 10:59:10 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23)
 Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: "Stephen Rothwell" <sfr@canb.auug.org.au>
cc: "Greg KH" <greg@kroah.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Eliad Peller" <eliad@wizery.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "David Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: linux-next: manual merge of the staging tree with the net
 tree
References: <20111006155810.14a6b5c199edc388bbf11437@canb.auug.org.au>
In-Reply-To: <20111006155810.14a6b5c199edc388bbf11437@canb.auug.org.au>
X-WSS-ID: 6293B0DE3KO27918913-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2011 06:58 AM, Stephen Rothwell wrote:
> Hi Greg,
>
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/brcm80211/brcmsmac/mac80211_if.c between commit
> 37a41b4affa3 ("mac80211: add ieee80211_vif param to tsf functions") from
> the net tree and commit 3956b4a2ddb0 ("staging: brcm80211: remove locking
> macro definitions") from the staging tree.
>
> I fixed it up (which essentially means I used the staging tree version
> with one small change to the brcms_ops_conf_tx prototype) and can carry
> the fixes as necessary.

Thanks, Stephen

I had to make the mac80211 conf_tx callback change  for the mainline 
patch as well.

Acked.

Gr. AvS

