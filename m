Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758723Ab2C1U7w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 16:59:52 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:56473 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267Ab2C1U7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 16:59:51 -0400
Date: Wed, 28 Mar 2012 16:58:44 -0400 (EDT)
Message-Id: <20120328.165844.660501464236484620.davem@davemloft.net>
To: kaffeemonster@googlemail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, matt@ozlabs.org,
        eric.dumazet@gmail.com
Subject: Re: [REGRESSION][PATCH] bpf_jit drops the ball on indirect
 negative mem references
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAPwCz79wO=5zTZmCG+ePfRuEu-p_Vosi18bYZ-MVNZGOdbE3aQ@mail.gmail.com>
References: <CAPwCz79wO=5zTZmCG+ePfRuEu-p_Vosi18bYZ-MVNZGOdbE3aQ@mail.gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 28 Mar 2012 13:58:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please do not post patches as octet-stream attachments, post them
inline so that:

1) People can more easily review and quote the code in replies.

2) It actually gets logged properly in patchwork.

Otherwise I can guarentee your patch will get less attention than
you would like.

Thanks.
