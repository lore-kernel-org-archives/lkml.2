Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918Ab0GFCYO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 22:24:14 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36216
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752671Ab0GFCYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 22:24:12 -0400
Date: Mon, 05 Jul 2010 19:24:26 -0700 (PDT)
Message-Id: <20100705.192426.13754108.davem@davemloft.net>
To: tilman@imap.cc
Cc: isdn@linux-pingi.de, hjlipp@web.de, keil@b1-systems.de,
       i4ldeveloper@listserv.isdn4linux.de, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Documentation/isdn: CAPI controller interface
 amendment
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100705-patch-isdn-01.tilman@imap.cc>
References: <20100705-patch-isdn-00.tilman@imap.cc>
	<20100705-patch-isdn-01.tilman@imap.cc>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tilman Schmidt <tilman@imap.cc>
Date: Tue,  6 Jul 2010 02:18:22 +0200 (CEST)

> Mention that the CAPI controller methods load_firmware() and
> reset_ctr() are asynchronous, and should signal completion.
> 
> Impact: documentation
> Signed-off-by: Tilman Schmidt <tilman@imap.cc>

Applied to net-next-2.6

Please stop using "Impact: " tags, I just edit them out when
I add your changes.
