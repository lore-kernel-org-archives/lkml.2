Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932362Ab2JBVWG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 17:22:06 -0400
Received: from mail.vyatta.com ([76.74.103.46]:36892 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932181Ab2JBVWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 17:22:04 -0400
Date: Tue, 2 Oct 2012 14:21:28 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: David Miller <davem@davemloft.net>
Cc: rdunlap@xenotime.net, sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: linux-next: Tree for Oct 2 (vxlan.c)
Message-ID: <20121002142128.1d2fde14@nehalam.linuxnetplumber.net>
In-Reply-To: <20121002.143627.1565408497543880722.davem@davemloft.net>
References: <20121002163229.d377074dc8f6c029428faeaa@canb.auug.org.au>
	<506B3317.5090006@xenotime.net>
	<20121002.143627.1565408497543880722.davem@davemloft.net>
Organization: Vyatta
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Oct 2012 14:36:27 -0400 (EDT)
David Miller <davem@davemloft.net> wrote:

> From: Randy Dunlap <rdunlap@xenotime.net>
> Date: Tue, 02 Oct 2012 11:31:51 -0700
> 
> > on x86_64:
> > 
> > drivers/net/vxlan.c: In function 'vxlan_xmit':
> > drivers/net/vxlan.c:725:2: error: implicit declaration of function 'ip_select_ident'
> > 
> > That function is only defined when CONFIG_INET is enabled,
> > but it is disabled in this config.
> 
> This definitely depends upon INET, I'll add the Kconfig change
> to net-next, thanks.

Yup, thanks Dave.
