Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab0INMLy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 08:11:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999Ab0INMLv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 08:11:51 -0400
Date: Tue, 14 Sep 2010 14:05:45 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Shirley Ma <mashirle@us.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        xiaohui.xin@intel.com, netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/1] macvtap TX zero copy between guest and host
 kernel
Message-ID: <20100914120545.GC703@redhat.com>
References: <1284410580.13351.10.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284410580.13351.10.camel@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 01:43:00PM -0700, Shirley Ma wrote:
> This patch induces a new sock flag ZEROCOPY to avoid copy between
> userspace and kernel. macvtap is the first user of zero copy between
> guest and host kernel. It only uses when the lower device supports high
> memory DMA. The first set of patch only addresses transmission TX side.
> The test has shown big improvement on either CPU utilization reduction
> or BW increase on 10GbE Intel NIC. Performance data will be submitted in
> the coming email.
> 
> thanks
> Shirley

While others pointed out correctness issues with the patch,
I would still like to see the performance numbers, just so we
understand what's possible.

-- 
MST
