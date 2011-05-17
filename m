Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726Ab1EQWVj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 18:21:39 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:50302 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756632Ab1EQWVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 18:21:38 -0400
Subject: Re: [PATCH V5 4/6 net-next] vhost: vhost TX zero-copy support
From: Shirley Ma <mashirle@us.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: David Miller <davem@davemloft.net>, Eric Dumazet <eric.dumazet@gmail.com>,
        Avi Kivity <avi@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110517212827.GC7589@redhat.com>
References: <1305574484.3456.30.camel@localhost.localdomain>
	 <20110516204540.GD18148@redhat.com>
	 <1305579414.3456.49.camel@localhost.localdomain>
	 <20110516212401.GF18148@redhat.com>
	 <1305606683.10756.3.camel@localhost.localdomain>
	 <20110517055503.GA26989@redhat.com>
	 <1305645734.10756.14.camel@localhost.localdomain>
	 <20110517152840.GA2389@redhat.com>
	 <1305646444.10756.16.camel@localhost.localdomain>
	 <1305665419.10756.33.camel@localhost.localdomain>
	 <20110517212827.GC7589@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 May 2011 15:21:29 -0700
Message-ID: <1305670889.10756.42.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-18 at 00:28 +0300, Michael S. Tsirkin wrote:
> On Tue, May 17, 2011 at 01:50:19PM -0700, Shirley Ma wrote:
> > Resubmit the patch with most update. This patch passed some
> > live-migration test against RHEL6.2. I will run more stress test w/i
> > live migration.
> > 
> > Signed-off-by: Shirley Ma <xma@us.ibm.com>
> 
> Cool. cleanup path needs a fix - are you use you can
> not use kobj or some other existing refcounting?
> 
> Is perf regressiion caused by tx ring overrun gone now?
> 
> I added some comments about how we might be aqble
> to complete requests out of order but it's not a must.

Oops, I used the old version vhost patch instead of most update one.

I will integrate your comments below and submit V6 patch instead.

thanks
Shirley

