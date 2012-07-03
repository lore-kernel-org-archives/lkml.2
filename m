Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104Ab2GCMpw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 08:45:52 -0400
Received: from teranetworks.de ([188.40.78.98]:53818 "EHLO teranetworks.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177Ab2GCMpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 08:45:51 -0400
X-Greylist: delayed 413 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Jul 2012 08:45:51 EDT
Date: Tue, 3 Jul 2012 14:38:55 +0200
From: Andreas Herz <andi@geekosphere.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.5-rc5
Message-ID: <20120703123855.GM9358@workstation>
References: <CA+55aFws_u8A7tm8abOmnDe_orUY7LnjWpJwYzgXndvjoXRW8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+55aFws_u8A7tm8abOmnDe_orUY7LnjWpJwYzgXndvjoXRW8w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/06/12 at 16:55, Linus Torvalds wrote:
> Eric Dumazet (5):
>       net: remove skb_orphan_try()

Finally it's gone. Came with 2.6.35 and since then several weird issues
occured with some network applications. For example openswan was broken
as skb_orphan_try removed the skb->sk too soon and pakets with
fragmentation got lost/couldn't be determined.

-- 
Andreas Herz
