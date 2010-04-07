Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230Ab0DGDQi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 23:16:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38627 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753337Ab0DGDQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 23:16:30 -0400
Message-ID: <4BBBF9E9.4080504@redhat.com>
Date: Wed, 07 Apr 2010 11:20:09 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Pirko <jpirko@redhat.com>
Subject: Re: linux-next: manual merge of the net tree with Linus' tree
References: <20100407125836.3c7f1095.sfr@canb.auug.org.au>
In-Reply-To: <20100407125836.3c7f1095.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the net tree got a conflict in
> drivers/net/bonding/bond_main.c between commit
> 9e2e61fbf8ad016d24e4af0afff13505f3dd2a2a ("bonding: fix potential
> deadlock in bond_uninit()") from Linus' tree and commit
> 22bedad3ce112d5ca1eaf043d4990fa2ed698c87 ("net: convert multicast list to
> list_head") from the net tree.
> 
> Just context changes.  If fixed it up (see below) and can carry the fix
> for a while.

Hi, Stephen,

If I read the combined diff correctly, it looks fine for me.

Thanks for letting me know!

