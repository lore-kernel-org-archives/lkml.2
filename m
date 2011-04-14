Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758901Ab1DNO36 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 10:29:58 -0400
Received: from 94.43.138.210.xn.2iij.net ([210.138.43.94]:32851 "EHLO
	mail.st-paulia.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758837Ab1DNO35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 10:29:57 -0400
X-Greylist: delayed 351 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Apr 2011 10:29:57 EDT
Subject: Re: [PATCH 1/1] ipv6: RTA_PREFSRC support for ipv6 route source
 address selection
From: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
To: sclark46@earthlink.net
Cc: Daniel Walter <sahne@0x90.at>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        yoshfuji@linux-ipv6.org
In-Reply-To: <4DA6FE25.70608@earthlink.net>
References: <20110414071057.GB78446@0x90.at>  <4DA6FE25.70608@earthlink.net>
Content-Type: text/plain; charset="ISO-2022-JP"
Organization: USAGI Project
Date: Thu, 14 Apr 2011 23:24:00 +0900
Message-ID: <1302791040.9279.2.camel@takos>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Clark wrote:
> On 04/14/2011 03:10 AM, Daniel Walter wrote:
> > [ipv6] Add support for RTA_PREFSRC
> >
> > This patch allows a user to select the preferred source address
> > for a specific IPv6-Route. It can be set via a netlink message
> > setting RTA_PREFSRC to a valid IPv6 address which must be
> > up on the device the route will be bound to.

> What userspace application will be used to set this?

I do expect Daniel will submit appropriate patch for iproute2 package
shortly :-)

--yoshfuji

