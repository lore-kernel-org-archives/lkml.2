Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932989Ab0GOKRu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 06:17:50 -0400
Received: from borg.medozas.de ([188.40.89.202]:47482 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932922Ab0GOKRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 06:17:48 -0400
Date: Thu, 15 Jul 2010 12:17:46 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Patrick McHardy <kaber@trash.net>
cc: "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        herbert@gondor.hengli.com.au
Subject: Re: several messages
In-Reply-To: <4C3ED764.3060301@trash.net>
Message-ID: <alpine.LSU.2.01.1007151216170.19772@obet.zrqbmnf.qr>
References: <20100711150623.GA7420@redhat.com> <20100711151453.GA7563@redhat.com> <4C3ED764.3060301@trash.net>
User-Agent: Alpine 2.01 (LSU 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 2010-07-15 11:36, Patrick McHardy wrote:
>> +struct xt_CHECKSUM_info {
>> +	u_int8_t operation;	/* bitset of operations */
>
>Please use __u8 in public header files.
>
>> +#include <linux/in.h>
>
>Do you really need in.h?
>
>> + * $Id$
>
>Please no CVS IDs.
>
>> +	switch (c) {
>> +	case 'F':
>> +		if (*flags)
>> +			xtables_error(PARAMETER_PROBLEM,
>> +			        "CHECKSUM target: Only use --checksum-fill ONCE!");
>
>There is a helper function called xtables_param_act for checking double
>arguments and printing a standarized error message.

I took care of these for Xt-a.

