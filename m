Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745Ab0JSPdl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 11:33:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44686
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751409Ab0JSPdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 11:33:40 -0400
Date: Tue, 19 Oct 2010 08:34:03 -0700 (PDT)
Message-Id: <20101019.083403.102548912.davem@davemloft.net>
To: minyard@acm.org
Cc: eric.dumazet@gmail.com, linux-kernel@vger.kernel.org, yinghai@kernel.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH] ipmi: proper spinlocks initializations
From: David Miller <davem@davemloft.net>
In-Reply-To: <4CBDB99A.6020707@acm.org>
References: <1287499073.2676.117.camel@edumazet-laptop>
	<4CBDB99A.6020707@acm.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Corey Minyard <minyard@acm.org>
Date: Tue, 19 Oct 2010 10:30:34 -0500

> Looks good to me.
> 
> Acked-by: Corey Minyard <cminyard@mvista.com>

Acked-by: David S. Miller <davem@davemloft.net>
