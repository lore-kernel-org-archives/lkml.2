Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751702Ab2BQK7A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 05:59:00 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:42376 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751151Ab2BQK66 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 05:58:58 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH v2 2/2] adi: adapt to eth_hw_addr_random() and changes in arch/blackfin
Date: Fri, 17 Feb 2012 11:57:54 +0100
User-Agent: KMail/1.9.10
Cc: "David S. Miller" <davem@davemloft.net>,
        Sonic Zhang <sonic.zhang@analog.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Bob Liu <bob.liu@analog.com>, uclinux-dist-devel@blackfin.uclinux.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1329412171-20704-1-git-send-email-danny.kukawka@bisect.de> <1329412171-20704-3-git-send-email-danny.kukawka@bisect.de> <CAMjpGUdAe66Nw16EyM1_dv4e8uHV02tcfqiuWL8ipeUrQ=HThg@mail.gmail.com>
In-Reply-To: <CAMjpGUdAe66Nw16EyM1_dv4e8uHV02tcfqiuWL8ipeUrQ=HThg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201202171157.55585.danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1329476338;82bda794;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Freitag, 17. Februar 2012, Mike Frysinger wrote:
> On Thu, Feb 16, 2012 at 12:09, Danny Kukawka wrote:
> > +                       netdev_warn(ndev, "Setting Ethernet MAC to a
> > random one\n"); +                       eth_hw_addr_random(ndev);
>
> would it make sense to have the core dump the warning ?

Maybe. Many drivers already print information about setting a random mac 
address to a netdevice. Some with printk, some via 
netdev_warn/netdev_info/netdev_dbg or netif_dbg and other with costum 
methods. I could unify this, in a next step with a netdev_info in 
eth_hw_addr_random(), if it's okay for David. 

Danny
