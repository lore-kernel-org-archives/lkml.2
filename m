Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798Ab3AJLHc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 06:07:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11767 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753707Ab3AJLHa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 06:07:30 -0500
Date: Thu, 10 Jan 2013 13:11:17 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Sjur =?iso-8859-1?Q?Br=E6ndeland?= <sjurbren@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        virtualization@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFCv2 00/12] Introduce host-side virtio queue and CAIF Virtio.
Message-ID: <20130110111117.GE13451@redhat.com>
References: <871ug75vp1.fsf@rustcorp.com.au>
 <1354718230-4486-1-git-send-email-sjur@brendeland.net>
 <20121206102750.GF10837@redhat.com>
 <877goc0wac.fsf@rustcorp.com.au>
 <CAJK669bP41oBhJ=MB64NS21Ag7XO5WswuTiVKCFTb96nvmyBiw@mail.gmail.com>
 <87pq1f2rj0.fsf@rustcorp.com.au>
 <87wqvl1g9s.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wqvl1g9s.fsf@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 09:00:55PM +1030, Rusty Russell wrote:
> Not sure why vring/net doesn't built a packet and feed it in
> netif_rx_ni().  This is what tun seems to do, and with this code it
> should be fairly optimal.

Because we want to use NAPI.

-- 
MST
