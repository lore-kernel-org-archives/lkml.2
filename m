Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277Ab2DEXTs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 19:19:48 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:38184 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab2DEXTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 19:19:46 -0400
Date: Fri, 6 Apr 2012 08:19:42 +0900
From: Simon Horman <horms@verge.net.au>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: wensong@linux-vs.org, ja@ssi.bg, kaber@trash.net, davem@davemloft.net,
        davej@redhat.com, netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: ipvs: Verify that IP_VS protocol has been
 registered
Message-ID: <20120405231942.GB7715@verge.net.au>
References: <1333668273-8873-1-git-send-email-levinsasha928@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333668273-8873-1-git-send-email-levinsasha928@gmail.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 05, 2012 at 07:24:33PM -0400, Sasha Levin wrote:
> The registration of a protocol might fail, there were no checks
> and all registrations were assumed to be correct. This lead to
> NULL ptr dereferences when apps tried registering.

Thanks, I will queue up this fix.

Do you have a real-world example of this failing, if so it
might be worth pushing your change into stable.
