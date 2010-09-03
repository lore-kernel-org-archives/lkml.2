Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab0ICExE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 00:53:04 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:56899 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab0ICExC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 00:53:02 -0400
Date: Fri, 3 Sep 2010 12:52:55 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: David Miller <davem@davemloft.net>, Dave Jones <davej@redhat.com>,
        netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cls_cgroup: Fix rcu lockdep warning
Message-ID: <20100903045255.GB28300@gondor.apana.org.au>
References: <4C7F446F.8040303@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C7F446F.8040303@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 02, 2010 at 02:30:07PM +0800, Li Zefan wrote:
> Calling task_subsys_state() without holding rcu_read_lock or
> cgroup_mutex can cause lockdep warning.
> 
> Reported-by: Dave Jones <davej@redhat.com>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks for catching this.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
