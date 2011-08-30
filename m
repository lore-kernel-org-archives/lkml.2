Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755700Ab1H3QNm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 12:13:42 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:41616 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755641Ab1H3QNk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 12:13:40 -0400
Subject: Re: [PATCH 06/24] netfilter: Remove unnecessary OOM logging
 messages
From: Joe Perches <joe@perches.com>
To: Patrick McHardy <kaber@trash.net>
Cc: Bart De Schuymer <bart.de.schuymer@pandora.be>,
        Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>, Julian Anastasov <ja@ssi.bg>,
        Stephen Hemminger <shemminger@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, bridge@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lvs-devel@vger.kernel.org
In-Reply-To: <4E5CDBAA.6040001@trash.net>
References: <cover.1314650069.git.joe@perches.com>
	 <13c1c12486cae409dfa5254b1435e660f2b17e05.1314650069.git.joe@perches.com>
	 <4E5CDBAA.6040001@trash.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Aug 2011 09:13:38 -0700
Message-ID: <1314720818.14422.1.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-30 at 14:46 +0200, Patrick McHardy wrote:
> On 29.08.2011 23:17, Joe Perches wrote:
> > Removing unnecessary messages saves code and text.
> > Site specific OOM messages are duplications of a generic MM
> > out of memory message and aren't really useful, so just
> > delete them.
> Looks good to me. Do you want me to apply this patch or are you
> intending to have the entire series go through Dave?

It doesn't matter to me one way or another.

If you pick this one up, when I redo these
to separate vmalloc from the the other alloc
cases, I'll won't send netfilter again.

cheers, Joe

