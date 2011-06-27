Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508Ab1F0JUc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 05:20:32 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55741 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757157Ab1F0JTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 05:19:04 -0400
Message-ID: <4E084AC2.5060908@mvista.com>
Date: Mon, 27 Jun 2011 13:17:54 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.18) Gecko/20110616 Thunderbird/3.1.11
MIME-Version: 1.0
To: Ralf Baechle <ralf@linux-mips.org>
CC: "David S. Miller" <davem@davemloft.net>, Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Paul Mundt <lethal@linux-sh.org>, Jeff Garzik <jeff@garzik.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sh@vger.kernel.org, netdev@vger.kernel.org,
        linux-mips@linux-mips.org
Subject: Re: [PATCH] NET: AX88796: Tighten up Kconfig dependencies
References: <20110625180050.GA9620@linux-mips.org>
In-Reply-To: <20110625180050.GA9620@linux-mips.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 25-06-2011 22:00, Ralf Baechle wrote:

> In def47c5095d53814512bb0c62ec02dfdec769db1 the AX88796 driver got

    Please also specify the summary of that commit.

> restricted to just be build for ARM and MIPS on the sole merrit that it

    Merit?

> was written for some ARM sytems and the driver had the missfortune to

    Misfortune?

> just build on MIPS, so MIPS was throw into the dependency for a good
> measure.  Later 8687991a734a67f1638782c968f46fff0f94bb1f added SH but

    Summary here too, please.

> only one in-tree SH system actually has an AX88796.

> Tighten up dependencies by using an auxilliary config sysmbol
> HAS_NET_AX88796 which is selected only by the platforms that actually
> have or may have an AX88796.  This also means the driver won't be built
> anymore for any MIPS platform.

> Signed-off-by: Ralf Baechle<ralf@linux-mips.org>

WBR, Sergei
