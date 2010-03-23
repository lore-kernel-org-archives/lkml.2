Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988Ab0CWFNS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 01:13:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39989 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924Ab0CWFNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 01:13:16 -0400
Message-ID: <4BA84E6C.5030503@redhat.com>
Date: Tue, 23 Mar 2010 13:15:24 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: mpm@selenic.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       bridge@lists.linux-foundation.org, gospo@redhat.com,
       nhorman@tuxdriver.com, shemminger@linux-foundation.org,
       bonding-devel@lists.sourceforge.net, fubar@us.ibm.com,
       jmoyer@redhat.com
Subject: Re: [RFC Patch 1/3] netpoll: add generic support for bridge and bonding
 devices
References: <4BA823D7.4010106@redhat.com>	<20100322.204939.146100390.davem@davemloft.net>	<4BA847EB.9040808@redhat.com> <20100322.215822.123414773.davem@davemloft.net>
In-Reply-To: <20100322.215822.123414773.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Cong Wang <amwang@redhat.com>
> Date: Tue, 23 Mar 2010 12:47:39 +0800
> 
>> Yeah, for bonding case, probably. But for bridge case, I think
>> we still need to check all, right?
> 
> Why?  Who cares?
> 
> If it goes out one port and reaches it's destination
> the objective has been achieved.
> 
> Sending it out N more times achieves nothing.

We have to check which port has the right destination.

Ideally we should check the right destination address to
choose the port, but currently we don't have a generic
way to check this, thus I chose to send it to all ports.
You are right, this needs to be improved.

Thanks!

