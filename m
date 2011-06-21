Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757204Ab1FUSFH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 14:05:07 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:41096 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756943Ab1FUSFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 14:05:05 -0400
Date: Tue, 21 Jun 2011 15:05:21 -0300
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hedberg <johan.hedberg@intel.com>
Subject: Re: linux-next: manual merge of the wireless tree with the
 wireless-current tree
Message-ID: <20110621180521.GC2628@joana>
Mail-Followup-To: Stephen Rothwell <sfr@canb.auug.org.au>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	Johan Hedberg <johan.hedberg@intel.com>
References: <20110621114957.59fae11d.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110621114957.59fae11d.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

* Stephen Rothwell <sfr@canb.auug.org.au> [2011-06-21 11:49:57 +1000]:

> Hi John,
> 
> Today's linux-next merge of the wireless tree got a conflict in
> net/bluetooth/l2cap_core.c between commit df3c3931ec58 ("Bluetooth: Fix
> accepting connect requests for defer_setup") from the wireless-current
> tree and commit ab07801d2898 ("Bluetooth: create channel timer to replace
> sk_timer") from the wireless tree.

I merged bluetooth-2.6 and bluetooth-next-2.6 to fix this and will send a pull
request to you in a minute.

	Gustavo
