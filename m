Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406Ab1KWVBr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 16:01:47 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:38755 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535Ab1KWVBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 16:01:46 -0500
Date: Wed, 23 Nov 2011 16:01:43 -0500 (EST)
Message-Id: <20111123.160143.58902472755124590.davem@davemloft.net>
To: gdfuego@gmail.com
Cc: richard.weinberger@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: Finding a hidden bound TCP socket
From: David Miller <davem@davemloft.net>
In-Reply-To: <CALmbKGVUuZs+wigpkr0WPfn2pYP=tQh5-MsYWeRxbug=HskVQQ@mail.gmail.com>
References: <CALmbKGV0g2nfNAghF5dGrt=TCyrms6RznOL8jSkg+gkgyfekLg@mail.gmail.com>
	<CAFLxGvynabpEcX2RwiLxatjOEzizj95jAVY6E4D9ymDpn8s9UA@mail.gmail.com>
	<CALmbKGVUuZs+wigpkr0WPfn2pYP=tQh5-MsYWeRxbug=HskVQQ@mail.gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 23 Nov 2011 13:01:45 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "G. D. Fuego" <gdfuego@gmail.com>
Date: Wed, 23 Nov 2011 15:27:33 -0500

> Any comments?  The behavior seems broken.  At the very least its very
> inconsistent with other Unixes.

Until the socket has a full final tuple it is bound to, there is no
reason to list it.

No UNIX lists a socket which is partially bound and hasn't either
performed a listen() or a connect().

Nobody has any comments because nobody thinks it's worth worrying about.
