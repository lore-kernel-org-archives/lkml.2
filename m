Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817Ab2APNfc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 08:35:32 -0500
Received: from spaceboyz.net ([87.106.131.203]:46703 "EHLO spaceboyz.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752066Ab2APNfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 08:35:30 -0500
Date: Mon, 16 Jan 2012 14:35:05 +0100
From: David Lamparter <equinox@diac24.net>
To: =?utf-8?Q?=C5=A0tefan?= Gula <steweg@gmail.com>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "David S. Miller" <davem@davemloft.net>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch v1, kernel version 3.2.1] net/ipv4/ip_gre: Ethernet
 multipoint GRE over IP
Message-ID: <20120116133505.GE1077372@jupiter.n2.diac24.net>
References: <CAGsizzJTbGGpwrn-P=SUtqBW=1AN6hCTVXKp_oKHPBAoGZ4ubA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsizzJTbGGpwrn-P=SUtqBW=1AN6hCTVXKp_oKHPBAoGZ4ubA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 01:13:19PM +0100, Štefan Gula wrote:
> it learns IP address of peer which encapsulated given packet.

This feature is already present in the Linux kernel, albeit only for IP
to IP lookup. Please look at "userspace ARPd" and its relation to
multipoint GRE. OpenNHRP is the associated userspace part.

That code reuses the existing neighbor management infrastructure. Adding
support for gretap and automatic learning from incoming packets
shouldn't be too hard...


-David
