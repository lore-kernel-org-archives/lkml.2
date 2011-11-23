Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab1KWUcP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 15:32:15 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63890 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918Ab1KWUcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 15:32:13 -0500
Message-ID: <1322080329.2775.8.camel@edumazet-laptop>
Subject: Re: Finding a hidden bound TCP socket
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "G. D. Fuego" <gdfuego@gmail.com>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Date: Wed, 23 Nov 2011 21:32:09 +0100
In-Reply-To: <CALmbKGVUuZs+wigpkr0WPfn2pYP=tQh5-MsYWeRxbug=HskVQQ@mail.gmail.com>
References: <CALmbKGV0g2nfNAghF5dGrt=TCyrms6RznOL8jSkg+gkgyfekLg@mail.gmail.com>
	 <CAFLxGvynabpEcX2RwiLxatjOEzizj95jAVY6E4D9ymDpn8s9UA@mail.gmail.com>
	 <CALmbKGVUuZs+wigpkr0WPfn2pYP=tQh5-MsYWeRxbug=HskVQQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 23 novembre 2011 à 15:27 -0500, G. D. Fuego a écrit :
> Any comments?  The behavior seems broken.  At the very least its very
> inconsistent with other Unixes.

Feel free to send a patch ;)

A user/process can consume all ports anyway, the 65000 port range is so
small...



