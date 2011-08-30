Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763Ab1H3Mqi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 08:46:38 -0400
Received: from stinky.trash.net ([213.144.137.162]:54661 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645Ab1H3Mqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 08:46:36 -0400
Message-ID: <4E5CDBAA.6040001@trash.net>
Date: Tue, 30 Aug 2011 14:46:34 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100620 Icedove/3.0.5
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Bart De Schuymer <bart.de.schuymer@pandora.be>,
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
Subject: Re: [PATCH 06/24] netfilter: Remove unnecessary OOM logging messages
References: <cover.1314650069.git.joe@perches.com> <13c1c12486cae409dfa5254b1435e660f2b17e05.1314650069.git.joe@perches.com>
In-Reply-To: <13c1c12486cae409dfa5254b1435e660f2b17e05.1314650069.git.joe@perches.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.08.2011 23:17, Joe Perches wrote:
> Removing unnecessary messages saves code and text.
> 
> Site specific OOM messages are duplications of a generic MM
> out of memory message and aren't really useful, so just
> delete them.

Looks good to me. Do you want me to apply this patch or are you
intending to have the entire series go through Dave?
