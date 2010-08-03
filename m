Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab0HCAZW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 20:25:22 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46730
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751178Ab0HCAZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 20:25:20 -0400
Date: Mon, 02 Aug 2010 17:25:38 -0700 (PDT)
Message-Id: <20100802.172538.220060944.davem@davemloft.net>
To: apetlund@simula.no
Cc: johunt@akamai.com, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        juhlenko@akamai.com
Subject: Re: [PATCH] net: Add getsockopt support for TCP thin-streams
From: David Miller <davem@davemloft.net>
In-Reply-To: <4C56B018.8030309@simula.no>
References: <1280533775-7700-1-git-send-email-johunt@akamai.com>
	<4C56B018.8030309@simula.no>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Petlund <apetlund@simula.no>
Date: Mon, 02 Aug 2010 13:46:32 +0200

> On 07/31/2010 01:49 AM, Josh Hunt wrote:
>> Initial TCP thin-stream commit did not add getsockopt support for the new
>> socket options: TCP_THIN_LINEAR_TIMEOUTS and TCP_THIN_DUPACK. This adds support
>> for them.
>> 
>> Signed-off-by: Josh Hunt <johunt@akamai.com>
 ...
> Tested-by: Andreas Petlund <apetlund@simula.no>
> Acked-by: Andreas Petlund <apetlund@simula.no>

Applied, thanks.
