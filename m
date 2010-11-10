Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860Ab0KJSO1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 13:14:27 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56994
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754871Ab0KJSOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 13:14:25 -0500
Date: Wed, 10 Nov 2010 10:14:49 -0800 (PST)
Message-Id: <20101110.101449.104041941.davem@davemloft.net>
To: segooon@gmail.com
Cc: kernel-janitors@vger.kernel.org, jreuter@yaina.de, ralf@linux-mips.org,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: ax25: fix information leak to userland
From: David Miller <davem@davemloft.net>
In-Reply-To: <1289412757-11411-1-git-send-email-segooon@gmail.com>
References: <1289412757-11411-1-git-send-email-segooon@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vasiliy Kulikov <segooon@gmail.com>
Date: Wed, 10 Nov 2010 21:12:36 +0300

> Sometimes ax25_getname() doesn't initialize all members of fsa_digipeater
> field of fsa struct, also the struct has padding bytes between
> sax25_call and sax25_ndigis fields.  This structure is then copied to
> userland.  It leads to leaking of contents of kernel stack memory.
> 
> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>

Looks good to me, applied.

Thanks!
