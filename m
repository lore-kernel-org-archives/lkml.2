Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757661Ab2GFPbq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 11:31:46 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:53650 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683Ab2GFPbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 11:31:45 -0400
Date: Fri, 6 Jul 2012 17:20:06 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: hayeswang <hayeswang@realtek.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next 2/2] r8169: support RTL8168G
Message-ID: <20120706152006.GA6981@electric-eye.fr.zoreil.com>
References: <1340966060-2749-1-git-send-email-hayeswang@realtek.com> <1341221002-1522-1-git-send-email-hayeswang@realtek.com> <1341221002-1522-2-git-send-email-hayeswang@realtek.com> <20120704220458.GA1621@electric-eye.fr.zoreil.com> <43E32504589B47B9846C4E9DAF98BF60@realtek.com.tw>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43E32504589B47B9846C4E9DAF98BF60@realtek.com.tw>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hayeswang <hayeswang@realtek.com> :
> Francois Romieu [romieu@fr.zoreil.com]
[...]
> > - fix r8168g_mdio_write (if (reg_addr == 0x1f) { if (reg_addr == 0) snafu)
> >   -> Please check this one.
> 
> That is fine.

Thanks, I'll merge your patch and feed both drivers to davem.

-- 
Ueimor
