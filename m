Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933948Ab0J2Oa4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 10:30:56 -0400
Received: from stinky.trash.net ([213.144.137.162]:40101 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756976Ab0J2Oay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 10:30:54 -0400
Message-ID: <4CCADA8D.3030808@trash.net>
Date: Fri, 29 Oct 2010 16:30:37 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Stephen Hemminger <shemminger@vyatta.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: netfilter: nf_nat: make find/put static
References: <201010231923.o9NJN2oc012438@hera.kernel.org> <AANLkTikuvBb79Q-mKK-u3tL=f433Om4T3NqJUynv=8=w@mail.gmail.com>
In-Reply-To: <AANLkTikuvBb79Q-mKK-u3tL=f433Om4T3NqJUynv=8=w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 28.10.2010 20:42, schrieb Geert Uytterhoeven:
> On Sat, Oct 23, 2010 at 21:23, Linux Kernel Mailing List
> <linux-kernel@vger.kernel.org> wrote:
>>    netfilter: nf_nat: make find/put static
>>
>>    ...
> 
> They should be moved inside the
> "#if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)",
> as I now get:
> 
> net/ipv4/netfilter/nf_nat_core.c:52: warning: ‘nf_nat_proto_find_get’
> defined but not used
> net/ipv4/netfilter/nf_nat_core.c:66: warning: ‘nf_nat_proto_put’
> defined but not used

Thanks, I'll fix this up.
