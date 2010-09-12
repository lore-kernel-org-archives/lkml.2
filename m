Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635Ab0ILPyw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 11:54:52 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58502
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751960Ab0ILPyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 11:54:51 -0400
Date: Sun, 12 Sep 2010 08:55:09 -0700 (PDT)
Message-Id: <20100912.085509.193705327.davem@davemloft.net>
To: pvp-lsts@fs.uni-ruse.bg
Cc: rjw@sisk.pl, jarkao2@gmail.com, eric.dumazet@gmail.com,
        herbert@gondor.hengli.com.au, kernel-testers@vger.kernel.org,
        maciej.rutecki@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, stable@kernel.org
Subject: Re: [Bug #16626] Machine hangs with EIP at skb_copy_and_csum_dev
From: David Miller <davem@davemloft.net>
In-Reply-To: <4C8C7957.7080207@fs.uni-ruse.bg>
References: <20100908.103256.112592448.davem@davemloft.net>
	<201009082221.16356.rjw@sisk.pl>
	<4C8C7957.7080207@fs.uni-ruse.bg>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Plamen Petrov <pvp-lsts@fs.uni-ruse.bg>
Date: Sun, 12 Sep 2010 09:55:19 +0300

> Now that both commits that fix my problems are in Linus' tree, the
> bug can be closed, but these fixes should go in 2.6.35.y, too.
> So, CCing -stable.

You don't need to do this, I will submit whatever is appropriate for
networking to -stable as needed.
