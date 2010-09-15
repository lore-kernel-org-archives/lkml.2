Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730Ab0IORAg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 13:00:36 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:41630 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009Ab0IORAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 13:00:35 -0400
Subject: Re: [RFC PATCH 2/2] macvtap: TX zero copy between guest and host
 kernel
From: Shirley Ma <mashirle@us.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Avi Kivity <avi@redhat.com>,
        "Xin, Xiaohui" <xiaohui.xin@intel.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20100915153927.GA1065@redhat.com>
References: <1284483745.13351.71.camel@localhost.localdomain>
	 <20100914182707.GB15549@redhat.com>
	 <1284490143.13351.82.camel@localhost.localdomain>
	 <20100914190156.GA16037@redhat.com>
	 <1284492983.13351.95.camel@localhost.localdomain>
	 <20100915051241.GA25340@redhat.com>
	 <1284531675.24603.259.camel@localhost.localdomain>
	 <20100915101000.GB28016@redhat.com>
	 <1284562354.2573.12.camel@localhost.localdomain>
	 <20100915150412.GA679@redhat.com>  <20100915153927.GA1065@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Sep 2010 10:00:04 -0700
Message-ID: <1284570004.2573.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-15 at 17:39 +0200, Michael S. Tsirkin wrote:
> In fact, I rechecked: both bridge and loopback have NETIF_F_HIGHDMA
> set.
> So maybe we should check NETIF_F_NETNS_LOCAL ...
> 
> macvtap in bridged mode is interesting as well. 

I found that too, just wondered which flag to use is better. :)

Thanks
Shirley

