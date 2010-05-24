Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117Ab0EXGwP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 02:52:15 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53270
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753393Ab0EXGwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 02:52:13 -0400
Date: Sun, 23 May 2010 23:52:23 -0700 (PDT)
Message-Id: <20100523.235223.116643622.davem@davemloft.net>
To: isdn@linux-pingi.de
Cc: tilman@imap.cc, hjlipp@web.de, i4ldeveloper@listserv.isdn4linux.de,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       keil@b1-systems.de
Subject: Re: [PATCH 0/2] ISDN fixes for 2.6.35
From: David Miller <davem@davemloft.net>
In-Reply-To: <201005231301.50967.isdn@linux-pingi.de>
References: <20100523-patch-gigaset-00.tilman@imap.cc>
	<201005231301.50967.isdn@linux-pingi.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Karsten Keil <isdn@linux-pingi.de>
Date: Sun, 23 May 2010 13:01:50 +0200

> On Sonntag, 23. Mai 2010 03:14:43 Tilman Schmidt wrote:
>> Karsten, David,
>> 
>> following are two patches to the CAPI subsystem and the Gigaset
>> driver I'd like to see included in kernel release 2.6.35.
>> Together they fix a reported hang of the userspace command
>> "capiinit stop".
> 
> Acked-by: Karsten Keil <isdn@linux-pingi.de>

All applied, thanks everyone.
