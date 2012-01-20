Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715Ab2ATVXd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 16:23:33 -0500
Received: from fieldses.org ([174.143.236.118]:33729 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754242Ab2ATVXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 16:23:31 -0500
Date: Fri, 20 Jan 2012 16:23:28 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: Trond.Myklebust@netapp.com, linux-nfs@vger.kernel.org, xemul@parallels.com,
        neilb@suse.de, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jbottomley@parallels.com, davem@davemloft.net, devel@openvz.org
Subject: Re: [PATCH] SUNRPC: search for service transports in network
 namespace context
Message-ID: <20120120212328.GA17859@fieldses.org>
References: <20120120125036.7468.2169.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120120125036.7468.2169.stgit@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 20, 2012 at 04:50:53PM +0400, Stanislav Kinsbursky wrote:
> Service transports are parametrized by network namespace. And thus lookup of
> transport instance have to take network namespace into account.
> 
> Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>

Looks OK to me.

Acked-by: J. Bruce Fields <bfields@redhat.com>

--b.
