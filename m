Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443Ab0CQVWG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 17:22:06 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58597
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753701Ab0CQVWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 17:22:04 -0400
Date: Wed, 17 Mar 2010 14:22:24 -0700 (PDT)
Message-Id: <20100317.142224.193700644.davem@davemloft.net>
To: tilman@imap.cc
Cc: isdn@linux-pingi.de, randy.dunlap@oracle.com, sfr@canb.auug.org.au,
       linux-next@vger.kernel.org, hjlipp@web.de,
       isdn4linux@listserv.isdn4linux.de, i4ldeveloper@listserv.isdn4linux.de,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] gigaset: fix build failure
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100317211231.569B140118@xenon.ts.pxnet.com>
References: <20100317211231.569B140118@xenon.ts.pxnet.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tilman Schmidt <tilman@imap.cc>
Date: Wed, 17 Mar 2010 18:37:05 +0100

> Update the dummy LL interface to the LL interface change
> introduced by commit daab433c03c15fd642c71c94eb51bdd3f32602c8.
> This fixes the build failure occurring after that commit when
> enabling ISDN_DRV_GIGASET but neither ISDN_I4L nor ISDN_CAPI.
> 
> Impact: bugfix
> Signed-off-by: Tilman Schmidt <tilman@imap.cc>

Applied, thanks.
