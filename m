Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab0LAQPF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 11:15:05 -0500
Received: from mail.vyatta.com ([76.74.103.46]:38965 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752090Ab0LAQPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 11:15:03 -0500
Date: Wed, 1 Dec 2010 08:14:57 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jiri Pirko <jpirko@redhat.com>,
        Neil Horman <nhorman@redhat.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        bonding-devel@lists.sourceforge.net, Jay Vosburgh <fubar@us.ibm.com>
Subject: Re: [Patch] bonding: clean up netpoll code
Message-ID: <20101201081457.23102445@nehalam>
In-Reply-To: <20101201075043.5741.29172.sendpatchset@localhost.localdomain>
References: <20101201075043.5741.29172.sendpatchset@localhost.localdomain>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Dec 2010 02:45:45 -0500
Amerigo Wang <amwang@redhat.com> wrote:

> +	if ((slave_dev->npinfo = bond_netpoll_info(bond))) {

Split assignment and conditional into two lines


-- 
