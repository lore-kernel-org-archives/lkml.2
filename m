Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465Ab1BNXG0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 18:06:26 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:33569 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365Ab1BNXGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 18:06:24 -0500
Subject: Re: [RFC PATCH V2 0/5] macvtap TX zero copy between guest and host
 kernel
From: Shirley Ma <mashirle@us.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        xiaohui.xin@intel.com, netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110214130957.GA3128@redhat.com>
References: <1291974691.2167.24.camel@localhost.localdomain>
	 <20110214130957.GA3128@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Feb 2011 15:06:19 -0800
Message-ID: <1297724779.14710.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-14 at 15:09 +0200, Michael S. Tsirkin wrote:
> What's the status here?  Since there are core net changes, we'll need
> to
> see the final version soon if it's to appear in 2.6.39.

I am updating the patch and retesting it for the new kernel. I am trying
to understand why zero copy patch caused small message size guest exits
doubled.

> Could the problem be related to the patch
>         virtio_net: Add schedule check to napi_enable call
> ?

Not sure, I will retest w/i this patch.

> Also, I expect there should be driver patches for some
> devices? Where are they? 

Yes, a NET_F_ZEROCOPY... flag is introduced for the device we we want to
support zero copy.

Thanks
Shirley

