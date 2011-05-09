Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547Ab1EIEOP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 00:14:15 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56362
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750928Ab1EIEOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 00:14:14 -0400
Date: Sun, 08 May 2011 21:13:41 -0700 (PDT)
Message-Id: <20110508.211341.226779345.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the net tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110509134613.bcf0b017.sfr@canb.auug.org.au>
References: <20110509134613.bcf0b017.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 9 May 2011 13:46:13 +1000

> Hi all,
> 
> After merging the net tree, today's linux-next build (x86_64 allmodconfig)
> produced this warning:
> 
> net/sctp/protocol.c: In function 'sctp_v4_xmit':
> net/sctp/protocol.c:842: warning: format '%p' expects type 'void *', but argument 5 has type '__be32'
> net/sctp/protocol.c:842: warning: format '%p' expects type 'void *', but argument 6 has type '__be32'
> 
> Caused by commit f1c0a276ea17 ("sctp: Don't use rt->rt_{src,dst} in
> sctp_v4_xmit()").

I'll fix this, thanks for the report Stephen.
