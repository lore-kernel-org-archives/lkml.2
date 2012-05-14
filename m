Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215Ab2ENTV4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 15:21:56 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56728 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755118Ab2ENTVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 15:21:54 -0400
Subject: Re: [PATCH RFC] tun: experimental zero copy tx support
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>,
        "David S. Miller" <davem@davemloft.net>, Joe Perches <joe@perches.com>,
        Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ian.Campbell@citrix.com,
        kvm@vger.kernel.org
In-Reply-To: <20120514191456.GC17086@redhat.com>
References: <20120513155206.GA26847@redhat.com>
	 <20120514095446.3ce307d2@nehalam.linuxnetplumber.net>
	 <20120514170412.GA17086@redhat.com>
	 <1337022146.8512.606.camel@edumazet-glaptop>
	 <20120514191456.GC17086@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 May 2012 21:21:47 +0200
Message-ID: <1337023307.8512.617.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-14 at 22:14 +0300, Michael S. Tsirkin wrote:

> They seem to be in net-next, or did I miss something?

Yes, you re-introduce in this patch some bugs already fixed in macvtap



