Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933134Ab1EZTL2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 15:11:28 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:44923 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757985Ab1EZTL0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 15:11:26 -0400
Subject: Re: [PATCH V5 2/6 net-next] netdevice.h: Add zero-copy flag in
 netdevice
From: Shirley Ma <mashirle@us.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: =?UTF-8?Q?Micha=C5=82_Miros=C5=82aw?= <mirqus@gmail.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, Avi Kivity <avi@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20110526084916.GA17928@redhat.com>
References: <1305729507.32080.6.camel@localhost.localdomain>
	 <20110518154746.GA21378@redhat.com>
	 <1305734857.32080.53.camel@localhost.localdomain>
	 <20110518163633.GB22001@redhat.com>
	 <1305737140.32080.59.camel@localhost.localdomain>
	 <20110518165138.GD22001@redhat.com>
	 <1305738028.32080.66.camel@localhost.localdomain>
	 <1305834169.32080.81.camel@localhost.localdomain>
	 <20110519234154.GA13784@redhat.com>
	 <1306363780.26270.44.camel@localhost.localdomain>
	 <20110526084916.GA17928@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 May 2011 12:11:17 -0700
Message-ID: <1306437077.5180.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-26 at 11:49 +0300, Michael S. Tsirkin wrote:
> > 
> > > - SG support
> > > - HIGHDMA support (on arches where this makes sense)
> > 
> > This can be checked by device flags.
> 
> OK, but pls note that SG can get turned off dynamically.

Tested the patch w/i SG dynmically on/off and tcpdump suspended.

