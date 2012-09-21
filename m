Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852Ab2IUT2t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 15:28:49 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46675 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225Ab2IUT2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 15:28:47 -0400
Subject: Re: [PATCH v3] ipconfig: add nameserver IPs to kernel-parameter ip=
From: Christoph Fritz <chf.fritz@googlemail.com>
To: David Miller <davem@davemloft.net>
Cc: rob@landley.net, kuznet@ms2.inr.ac.ru, j.weitzel@phytec.de,
        jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, hjk@hansjkoch.de, daniel@zonque.org
In-Reply-To: <20120921.145144.14955032475453606.davem@davemloft.net>
References: <1348177730.3858.98.camel@mars>
	 <20120921.133759.1667263015470766968.davem@davemloft.net>
	 <1348252279.12456.2.camel@mars>
	 <20120921.145144.14955032475453606.davem@davemloft.net>
Content-Type: text/plain; charset="us-ascii"
Date: Fri, 21 Sep 2012 21:28:33 +0200
Message-ID: <1348255713.12456.43.camel@mars>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-21 at 14:51 -0400, David Miller wrote:
> From: Christoph Fritz <chf.fritz@googlemail.com>
> Date: Fri, 21 Sep 2012 20:31:19 +0200
> 
> > On small systems (e.g. embedded ones) IP addresses are often configured
> > by bootloaders and get assigned to kernel via parameter "ip=".  If set to
> > "ip=dhcp", even nameserver entries from DHCP daemons are handled. These
> > entries exported in /proc/net/pnp are commonly linked by /etc/resolv.conf.
> > 
> > To configure nameservers for networks without DHCP, this patch adds option
> > <dns0-ip> and <dns1-ip> to kernel-parameter 'ip='.
> > 
> > Signed-off-by: Christoph Fritz <chf.fritz@googlemail.com>
> > Tested-by: Jan Weitzel <j.weitzel@phytec.de>
> 
> Applied to net-next, thanks.

Thanks a lot for your reviews.

 -- Christoph

