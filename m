Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742Ab1KXVxv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 16:53:51 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53743 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab1KXVxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 16:53:49 -0500
Message-ID: <1322171624.2872.2.camel@edumazet-laptop>
Subject: Re: Finding a hidden bound TCP socket
From: Eric Dumazet <eric.dumazet@gmail.com>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Rick Jones <rick.jones2@hp.com>, David Miller <davem@davemloft.net>,
        gdfuego@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Date: Thu, 24 Nov 2011 22:53:44 +0100
In-Reply-To: <CAFLxGvzAV9ODxo6Bs=ow1J0JRwHYNFmkBqrmN33D7Ci=YvNKNg@mail.gmail.com>
References: <CALmbKGV0g2nfNAghF5dGrt=TCyrms6RznOL8jSkg+gkgyfekLg@mail.gmail.com>
	 <CAFLxGvynabpEcX2RwiLxatjOEzizj95jAVY6E4D9ymDpn8s9UA@mail.gmail.com>
	 <CALmbKGVUuZs+wigpkr0WPfn2pYP=tQh5-MsYWeRxbug=HskVQQ@mail.gmail.com>
	 <20111123.160143.58902472755124590.davem@davemloft.net>
	 <4ECD67C7.3010702@hp.com>
	 <CAFLxGvzAV9ODxo6Bs=ow1J0JRwHYNFmkBqrmN33D7Ci=YvNKNg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 24 novembre 2011 à 22:31 +0100, richard -rw- weinberger a
écrit :

> IRIX (6.5) shows them as "CLOSED".
> 

As I said, patches are welcome.



