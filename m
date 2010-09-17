Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738Ab0IQOTc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 10:19:32 -0400
Received: from mail.elliptictech.com ([209.217.122.41]:52348 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569Ab0IQOT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 10:19:29 -0400
Date: Fri, 17 Sep 2010 10:19:20 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: Regression, bisected: WARNING spam with ipsec since 2.6.35
Message-ID: <20100917141920.GA9280@elliptictech.com>
Mail-Followup-To: Eric Dumazet <eric.dumazet@gmail.com>,
	linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
	David Miller <davem@davemloft.net>
References: <20100916213138.GA6605@elliptictech.com>
 <1284676070.4784.25.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284676070.4784.25.camel@edumazet-laptop>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-09-17 00:27 +0200, Eric Dumazet wrote:
> I suspect following patch is needed, before further changes.
> 
> [PATCH] xfrm: dont assume rcu_read_lock in xfrm_output_one()

Yup, that makes the warnings go away.  Thanks.

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
