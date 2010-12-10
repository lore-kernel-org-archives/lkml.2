Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225Ab0LJUga (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 15:36:30 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33630
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756992Ab0LJUg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 15:36:29 -0500
Date: Fri, 10 Dec 2010 12:36:57 -0800 (PST)
Message-Id: <20101210.123657.15226119.davem@davemloft.net>
To: xiaohui.xin@intel.com
Cc: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com, mingo@elte.hu, herbert@gondor.hengli.com.au,
        jdike@linux.intel.com
Subject: Re: [PATCH v16 03/17] Add a ndo_mp_port_prep pointer to
 net_device_ops.
From: David Miller <davem@davemloft.net>
In-Reply-To: <cd0686f2b8fc16a1d87ced228b2a90b93f008b94.1291187695.git.xiaohui.xin@intel.com>
References: <fc6e95d63a2c62aaf77f8ded22fc43ccefcdbbff.1291187695.git.xiaohui.xin@intel.com>
	<fc6e95d63a2c62aaf77f8ded22fc43ccefcdbbff.1291187695.git.xiaohui.xin@intel.com>
	<cd0686f2b8fc16a1d87ced228b2a90b93f008b94.1291187695.git.xiaohui.xin@intel.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: xiaohui.xin@intel.com
Date: Wed,  1 Dec 2010 16:08:14 +0800

> +#if defined(CONFIG_MEDIATE_PASSTHRU) || defined(CONFIG_MEDIATE_PASSTHRU_MODULE)
> +	int			(*ndo_mp_port_prep)(struct net_device *dev,
> +						struct mp_port *port);
> +#endif

Please rename this config option so that it is clear, by name, that
this option is for a networking facility.

F.e. CONFIG_NET_MEDIATE_PASSTHRU
