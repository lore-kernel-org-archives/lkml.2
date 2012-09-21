Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312Ab2IURiG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 13:38:06 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:50756 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932070Ab2IURiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 13:38:03 -0400
Date: Fri, 21 Sep 2012 13:37:59 -0400 (EDT)
Message-Id: <20120921.133759.1667263015470766968.davem@davemloft.net>
To: chf.fritz@googlemail.com
Cc: rob@landley.net, kuznet@ms2.inr.ac.ru, j.weitzel@phytec.de,
        jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, hjk@hansjkoch.de, daniel@zonque.org
Subject: Re: [PATCH v2] ipconfig: add nameserver IPs to kernel-parameter ip=
From: David Miller <davem@davemloft.net>
In-Reply-To: <1348177730.3858.98.camel@mars>
References: <1348176485.3858.92.camel@mars>
	<20120920.173719.1238894522809866676.davem@davemloft.net>
	<1348177730.3858.98.camel@mars>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Fritz <chf.fritz@googlemail.com>
Date: Thu, 20 Sep 2012 23:48:50 +0200

> diff --git a/Documentation/filesystems/nfs/nfsroot.txt b/Documentation/filesystems/nfs/nfsroot.txt
> index ffdd9d8..4ed7875 100644
> --- a/Documentation/filesystems/nfs/nfsroot.txt
> +++ b/Documentation/filesystems/nfs/nfsroot.txt
> @@ -158,6 +158,13 @@ ip=<client-ip>:<server-ip>:<gw-ip>:<netmask>:<hostname>:<device>:<autoconf>
>  
>                  Default: any
>  
> +  <dns0-ip>	IP address of first nameserver.
> +		Value gets exported by /proc/net/pnp which is often linked
> +		on embedded systems by /etc/resolv.conf.
> +
> +  <dns1-ip>	IP address of secound nameserver.
> +		Same as above.
> +
>  
>  nfsrootdebug
>  

This documentation update is not sufficient.

You have to properly show, in the lines above where you made your change,
where the new settings are placed in the "ip=" option.
