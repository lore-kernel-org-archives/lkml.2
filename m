Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756998Ab2EQQJ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 12:09:28 -0400
Received: from mail.vyatta.com ([76.74.103.46]:35983 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753281Ab2EQQJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 12:09:26 -0400
Date: Thu, 17 May 2012 09:09:23 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Eldad Zack <eldad@fogrefinery.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, Jamal Hadi Salim <hadi@cyberus.ca>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipv6: correct the ipv6 option name - Pad0 to Pad1
Message-ID: <20120517090923.0d0930e9@nehalam.linuxnetplumber.net>
In-Reply-To: <1337270425-21873-1-git-send-email-eldad@fogrefinery.com>
References: <1337270425-21873-1-git-send-email-eldad@fogrefinery.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 May 2012 18:00:25 +0200
Eldad Zack <eldad@fogrefinery.com> wrote:

> The padding destination or hop-by-hop option is called Pad1 and not Pad0.
> 
> See RFC2460 (4.2) or the IANA ipv6-parameters registry:
> http://www.iana.org/assignments/ipv6-parameters/ipv6-parameters.xml
> 
> Signed-off-by: Eldad Zack <eldad@fogrefinery.com>

If standards bodies want to call a 0 a 1, then I guess we have to follow :-)
