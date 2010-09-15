Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332Ab0IOGRP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 02:17:15 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:55385 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450Ab0IOGRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 02:17:13 -0400
Subject: Re: [RFC PATCH 2/2] macvtap: TX zero copy between guest and host
 kernel
From: Shirley Ma <mashirle@us.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "Xin, Xiaohui" <xiaohui.xin@intel.com>, Avi Kivity <avi@redhat.com>,
        David Miller <davem@davemloft.net>, "arnd@arndb.de" <arnd@arndb.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20100915052724.GA25481@redhat.com>
References: <1284410580.13351.10.camel@localhost.localdomain>
	 <1284410883.13351.14.camel@localhost.localdomain>
	 <20100913.201730.27805132.davem@davemloft.net>
	 <4C8F3C77.7010302@redhat.com>
	 <1284476719.13351.35.camel@localhost.localdomain>
	 <F2E9EB7348B8264F86B6AB8151CE2D792B8C8152A0@shsmsx502.ccr.corp.intel.com>
	 <1284518452.13351.111.camel@localhost.localdomain>
	 <20100915052724.GA25481@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Sep 2010 23:17:08 -0700
Message-ID: <1284531428.24603.251.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-15 at 07:27 +0200, Michael S. Tsirkin wrote:
> For some of the issues, try following the discussion around
> net: af_packet: don't call tpacket_destruct_skb() until the skb is
> sent
> out.
> 
> Summary: it's difficult to do correctly generally. Limiting ourselves
> to transmit on specific devices might make it possible.

Thanks for the tips.

Shirley

