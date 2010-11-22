Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760Ab0KVQRJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 11:17:09 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38265
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756093Ab0KVQRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 11:17:07 -0500
Date: Mon, 22 Nov 2010 08:17:31 -0800 (PST)
Message-Id: <20101122.081731.226770168.davem@davemloft.net>
To: tdent48227@gmail.com
Cc: marcel@holtmann.org, padovan@profusion.mobi,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        sjur.brandeland@stericsson.com, socketcan@hartkopp.net,
        urs.thuermann@volkswagen.de, socketcan-core@lists.berlios.de,
        sage@newdream.net, ceph-devel@vger.kernel.org, wang840925@gmail.com,
        jlayton@redhat.com, kaber@trash.net, pekkas@netcore.fi,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org, samuel@sortiz.org
Subject: Re: [PATCH 00/00] Remove deprecated items from Makefiles
From: David Miller <davem@davemloft.net>
In-Reply-To: <1290387808-2239-1-git-send-email-tdent48227@gmail.com>
References: <1290387808-2239-1-git-send-email-tdent48227@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tracey Dent <tdent48227@gmail.com>
Date: Sun, 21 Nov 2010 20:03:11 -0500

> I changed Makefiles to use <modules>-y instead of <modules>-objs because -objs
> is deprecated and not even mentioned in Documentation/kbuild/makefiles.txt.
> 
> Also, remove some if-conditional statments because I used the ccflags-$ flag 
> instead of EXTRA_CFLAGS because EXTRA_CFLAGS.

All applied, thanks Tracey.
