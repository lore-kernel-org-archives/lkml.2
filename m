Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917Ab2GIKYN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 06:24:13 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:57185 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761Ab2GIKYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 06:24:11 -0400
Date: Mon, 9 Jul 2012 12:12:15 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        hayeswang <hayeswang@realtek.com>
Subject: Re: [PATCH net-next 1/2] r8169: support RTL8106E
Message-ID: <20120709101215.GA6530@electric-eye.fr.zoreil.com>
References: <1340966060-2749-1-git-send-email-hayeswang@realtek.com> <1341221002-1522-1-git-send-email-hayeswang@realtek.com> <1341221002-1522-2-git-send-email-hayeswang@realtek.com> <20120704220458.GA1621@electric-eye.fr.zoreil.com> <43E32504589B47B9846C4E9DAF98BF60@realtek.com.tw> <20120706152006.GA6981@electric-eye.fr.zoreil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120708.234857.1032244145219683435.davem@davemloft.net>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> :
> Francois, what would you like me to do with these two patches?  I
> haven't seen full ACKs from you yet.

You have two options:
- You can apply the first (8106) patch. I tested it. I'm ok with Hayes point.
  Consider it Acked.
- You wait for a pull request with both patches + the incremental bits for
  the second one. Some of the incremental bits are needed in the original
  patch itself while some make more sense before the patch itself.
  ETA: this evening or tomorrow morning at worst.

If you go for the first option, I'll simply skip the first patch and
apply again. It's the same work for me.

-- 
Ueimor
