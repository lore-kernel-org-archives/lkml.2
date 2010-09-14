Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073Ab0INTnW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 15:43:22 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:50865 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163Ab0INTnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 15:43:21 -0400
Subject: Re: 2.6.36-rc4/iwl: warning triggered in net/mac80211/scan.c:266
From: Johannes Berg <johannes@sipsolutions.net>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Reinette Chatre <reinette.chatre@intel.com>,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
In-Reply-To: <20100914151439.GA13028@redhat.com>
References: <20100914142814.GA8744@redhat.com>
	 <1284474988.3704.10.camel@jlt3.sipsolutions.net>
	 <20100914151439.GA13028@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Sep 2010 21:43:10 +0200
Message-ID: <1284493390.3703.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-14 at 17:14 +0200, Michael S. Tsirkin wrote:

> > No, it shouldn't happen. But there are various races in iwlwifi that can
> > cause this. Stanislaw has fixed them recently, but it's a fairly large
> > patchset. I'm not sure, but I don't think this is really new in .36.

> So ... get back to you after 2.6.37?

Err, yes, I guess so, though I suppose it doesn't really solve the
problem. This particular instance should be harmless though, I believe,
other than the warning.

johannes


