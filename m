Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440Ab1JLTP7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 15:15:59 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:47745 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002Ab1JLTP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 15:15:57 -0400
Message-ID: <1318446934.2644.0.camel@edumazet-laptop>
Subject: Re: [PATCH v4] net-netlink: Add a new attribute to expose TOS
 values via netlink
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Muraliraja Muniraju <muralira@google.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Date: Wed, 12 Oct 2011 21:15:34 +0200
In-Reply-To: <1318446035-10267-1-git-send-email-muralira@google.com>
References: <20111012085235.3b78729b@nehalam.linuxnetplumber.net>
	 <1318446035-10267-1-git-send-email-muralira@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 12 octobre 2011 à 12:00 -0700, Muraliraja Muniraju a écrit :
> From: Murali Raja <muralira@google.com>
> 
> This patch exposes the tos value for the TCP sockets when the TOS flag
> is requested in the ext_flags for the inet_diag request. This would mainly be
> used to expose TOS values for both for TCP and UDP sockets. Currently it is
> supported for TCP. When netlink support for UDP would be added the support
> to expose the TOS values would alse be done. For IPV4 tos value is exposed
> and for IPV6 tclass value is exposed.
> 
> Signed-off-by: Murali Raja <muralira@google.com>
> ---

Acked-by: Eric Dumazet <eric.dumazet@gmail.com>


