Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932995Ab0I0Nmi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 09:42:38 -0400
Received: from mail.solarflare.com ([216.237.3.220]:27485 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759341Ab0I0Nmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 09:42:37 -0400
Subject: Re: [PATCH v11 03/17] Add a ndo_mp_port_prep pointer to
 net_device_ops.
From: Ben Hutchings <bhutchings@solarflare.com>
To: xiaohui.xin@intel.com
Cc: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, davem@davemloft.net, herbert@gondor.hengli.com.au,
        jdike@linux.intel.com
In-Reply-To: <79267b300503d98d43ccfcf11d1374f59fec8578.1285385607.git.xiaohui.xin@intel.com>
References: <1285388855-27410-1-git-send-email-xiaohui.xin@intel.com>
	 <79267b300503d98d43ccfcf11d1374f59fec8578.1285385607.git.xiaohui.xin@intel.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Mon, 27 Sep 2010 14:42:33 +0100
Message-ID: <1285594953.2263.5.camel@achroite.uk.solarflarecom.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Sep 2010 13:42:37.0062 (UTC) FILETIME=[D8A6BA60:01CB5E49]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-17668.005
X-TM-AS-Result: No--12.820600-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-09-25 at 12:27 +0800, xiaohui.xin@intel.com wrote:
> From: Xin Xiaohui <xiaohui.xin@intel.com>
> 
> If the driver want to allocate external buffers,
> then it can export it's capability, as the skb
> buffer header length, the page length can be DMA, etc.
> The external buffers owner may utilize this.
[...]

This information needs to be included in the comment above struct
net_device_ops, not just in the commit message.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

