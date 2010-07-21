Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761314Ab0GUSuJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 14:50:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37865
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752774Ab0GUSuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 14:50:07 -0400
Date: Wed, 21 Jul 2010 11:50:23 -0700 (PDT)
Message-Id: <20100721.115023.69942880.davem@davemloft.net>
To: gregory.v.rose@intel.com
Cc: leedom@chelsio.com, shemminger@vyatta.com, andy@greyhouse.net,
        harald@redhat.com, bhutchings@solarflare.com, sassmann@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, gospo@redhat.com,
        alexander.h.duyck@intel.com
Subject: Re: [PATCH net-next] sysfs: add entry to indicate network
 interfaces with random MAC address
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100721.114851.200597269.davem@davemloft.net>
References: <201007211129.48288.leedom@chelsio.com>
	<43F901BD926A4E43B106BF17856F0755F184620A@orsmsx508.amr.corp.intel.com>
	<20100721.114851.200597269.davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Wed, 21 Jul 2010 11:48:51 -0700 (PDT)

> You could do things like have the PF controller use the root filesystem
> ID label to construct the VF's MAC address, or something like that.

And here I of course mean the root filesystem of the guest the VF will
be given to.
