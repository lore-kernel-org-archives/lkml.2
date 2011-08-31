Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422Ab1HaKNI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 06:13:08 -0400
Received: from stinky.trash.net ([213.144.137.162]:43086 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665Ab1HaKNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 06:13:04 -0400
Message-ID: <4E5E092E.80507@trash.net>
Date: Wed, 31 Aug 2011 12:13:02 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100620 Icedove/3.0.5
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: joe@perches.com, bart.de.schuymer@pandora.be, wensong@linux-vs.org,
        horms@verge.net.au, ja@ssi.bg, shemminger@linux-foundation.org,
        kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, bridge@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lvs-devel@vger.kernel.org
Subject: Re: [PATCH 06/24] netfilter: Remove unnecessary OOM logging messages
References: <cover.1314650069.git.joe@perches.com>	<13c1c12486cae409dfa5254b1435e660f2b17e05.1314650069.git.joe@perches.com>	<4E5CDBAA.6040001@trash.net> <20110830.135502.179848097213434762.davem@davemloft.net>
In-Reply-To: <20110830.135502.179848097213434762.davem@davemloft.net>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30.08.2011 19:55, David Miller wrote:
> From: Patrick McHardy <kaber@trash.net>
> Date: Tue, 30 Aug 2011 14:46:34 +0200
> 
>> On 29.08.2011 23:17, Joe Perches wrote:
>>> Removing unnecessary messages saves code and text.
>>>
>>> Site specific OOM messages are duplications of a generic MM
>>> out of memory message and aren't really useful, so just
>>> delete them.
>>
>> Looks good to me. Do you want me to apply this patch or are you
>> intending to have the entire series go through Dave?
> 
> I'm happy with subsystem folks taking things in if they want, the
> B.A.T.M.A.N. guys did this earlier today for example.

OK, thanks.

Applied after fixing up some minor rejects in nf_nat_snmp_basic.c,
thanks Joe.
