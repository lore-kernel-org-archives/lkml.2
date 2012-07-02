Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693Ab2GBPns (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 11:43:48 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:46554 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931Ab2GBPnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 11:43:46 -0400
Message-ID: <4FF1C1AF.9080104@collabora.co.uk>
Date: Mon, 02 Jul 2012 17:43:43 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Pablo Neira Ayuso <pablo@netfilter.org>
CC: Vincent Sanders <vincent.sanders@collabora.co.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Alban Crequy <alban.crequy@collabora.co.uk>
Subject: Re: [PATCH net-next 13/15] netfilter: nfdbus: Add D-bus message parsing
References: <1340988354-26981-1-git-send-email-vincent.sanders@collabora.co.uk> <1340988354-26981-14-git-send-email-vincent.sanders@collabora.co.uk> <20120629171108.GA6287@1984>
In-Reply-To: <20120629171108.GA6287@1984>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2012 07:11 PM, Pablo Neira Ayuso wrote:
> On Fri, Jun 29, 2012 at 05:45:52PM +0100, Vincent Sanders wrote:
>> From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
>> 
>> The netfilter D-Bus module needs to parse D-bus messages sent by
>> applications to decide whether a peer can receive or not a D-Bus
>> message. Add D-bus message parsing logic to be able to analyze.
> 
> Not talking about the entire patchset, only about the part I'm
> responsible for.
> 
> I don't see why you think this belong to netfilter at all.
> 
> This doesn't integrate into the existing filtering infrastructure,
> neither it extends it in any way.
> 

Hello Pablo,

Thanks a lot for your feedback.

This is the first of a set of patches that adds a netfilter module to parse
D-Bus messages, the complete patch-set is:

[PATCH 13/15] netfilter: nfdbus: Add D-bus message parsing
[PATCH 14/15] netfilter: nfdbus: Add D-bus match rule implementation
[PATCH 15/15] netfilter: add netfilter D-Bus module

patches 13 and 14 just include D-Bus helper code to be used by the netfilter
module (added on patch 15) and specially the dbus_filter netfilter hook function.

For the next post version we will reorganize the patches so first the D-Bus
netfilter module is added with an empty dbus_filter function and then added the
D-Bus helper code.

Also, we will move the nfdbus netfilter module to net/bus so is not inside the
netfilter core code.

Thanks a lot and best regards,
Javier
