Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab2GPR1X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 13:27:23 -0400
Received: from Mailrelay020.isp.belgacom.be ([195.238.6.95]:21916 "EHLO
	mailrelay020.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753180Ab2GPR1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 13:27:20 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmoLAF5OBFBXQAJK/2dsb2JhbABFhWmvdoI4AQMBA4EqgQiCIAEBBQQcNiIBEAsOCgkWDwkDAgECASceBg0BBwEBiA2pNwaSXoEeiiKFM4EUA5sRijCCYQ
Message-ID: <50044ED5.5070006@computer.org>
Date: Mon, 16 Jul 2012 19:26:45 +0200
From: Jan Ceuleers <jan.ceuleers@computer.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Andrew Vagin <avagin@parallels.com>
CC: Eric Dumazet <eric.dumazet@gmail.com>, Andrew Vagin <avagin@openvz.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>,
        Pavel Emelianov <xemul@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] net-next: make sock diag per-namespace
References: <1342440849-1757320-1-git-send-email-avagin@openvz.org> <1342441945.23494.23.camel@edumazet-glaptop> <20120716123815.GA1178@avaginn.sw.ru>
In-Reply-To: <20120716123815.GA1178@avaginn.sw.ru>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2012 02:38 PM, Andrew Vagin wrote:
> You are right. Sorry for this stupid fault. I will send a new patch.

Before doing so:

Could you put the "net-next" inside the square brackets (being the tree you are aiming your patch at, which should not end up in the commit log), and mention the subsystem in its place? Perhaps simply "net"?

Just a suggestion.

Thanks, Jan
