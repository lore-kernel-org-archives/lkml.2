Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab2KLX3z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 18:29:55 -0500
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:30781 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751523Ab2KLX3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 18:29:54 -0500
Date: Mon, 12 Nov 2012 23:29:52 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Shan Wei <shanwei88@gmail.com>, David Miller <davem@davemloft.net>,
        timo.teras@iki.fi, steffen.klassert@secunet.com,
        NetDev <netdev@vger.kernel.org>,
        Kernel-Maillist <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/9] net: core: use this_cpu_ptr per-cpu helper
In-Reply-To: <1352492144.19779.811.camel@edumazet-glaptop>
Message-ID: <0000013af6f524ea-0c223212-2fce-4162-83df-914fbc19c2cc-000000@email.amazonses.com>
References: <509C686F.20400@gmail.com> <0000013ae6c9e81a-eabe295b-72a5-4ebd-85c5-231bec1a70c5-000000@email.amazonses.com> <1352492144.19779.811.camel@edumazet-glaptop>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Nov 2012, Eric Dumazet wrote:

> Its not the case.
>
> We need the _pointer_ to call :
>
> tasklet_schedule(tasklet);

Ah. Ok. In that case

Reviewed-by: Christoph Lameter <cl@linux.com>

