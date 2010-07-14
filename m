Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313Ab0GNSDT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 14:03:19 -0400
Received: from claw.goop.org ([74.207.240.146]:49256 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754160Ab0GNSDS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 14:03:18 -0400
Message-ID: <4C3DFBE5.2020705@goop.org>
Date: Wed, 14 Jul 2010 11:03:17 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Lightning/1.0b2pre Thunderbird/3.0.5
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: pthakkar@vmware.com, pv-drivers@vmware.com, greg@kroah.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, hch@infradead.org,
        netdev@vger.kernel.org, shemminger@vyatta.com
Subject: Re: [Pv-drivers] RFC: Network Plugin Architecture (NPA) for vmxnet3
References: <1278990388.32650.22.camel@eng-rhel5-64>	<20100714094952.GA16209@kroah.com>	<F1354E79A137A24CBA60059AA65CB1B802A34EEB67@EXCH-MBX-2.vmware.com> <20100714.105423.226778756.davem@davemloft.net>
In-Reply-To: <20100714.105423.226778756.davem@davemloft.net>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2010 10:54 AM, David Miller wrote:
> And doing what you're doing is foolish on so many levels.  One more
> duplication of code, one more place for unnecessary bugs to live, one
> more place that might need optimizations and thus require duplication
> of even more work people have done over the years.
>   

Not to mention calling a function "MoveMemory" when it doesn't do a
memmove is just cruel.

    J
