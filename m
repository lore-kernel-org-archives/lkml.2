Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503Ab2E0FMZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 01:12:25 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:35855 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab2E0FMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 01:12:21 -0400
Date: Sun, 27 May 2012 01:09:07 -0400 (EDT)
Message-Id: <20120527.010907.594471916322063411.davem@davemloft.net>
To: bpoirier@suse.de
Cc: netdev@vger.kernel.org, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, linux-kernel@vger.kernel.org,
        steffen.klassert@secunet.com, diego.beltrami@gmail.com
Subject: Re: [PATCH v4] xfrm: take net hdr len into account for esp payload
 size calculation
From: David Miller <davem@davemloft.net>
In-Reply-To: <1337895158-23521-1-git-send-email-bpoirier@suse.de>
References: <20120517.200509.2290282427866555176.davem@davemloft.net>
	<1337895158-23521-1-git-send-email-bpoirier@suse.de>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sat, 26 May 2012 22:09:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Poirier <bpoirier@suse.de>
Date: Thu, 24 May 2012 17:32:38 -0400

> Corrects the function that determines the esp payload size. The calculations
> done in esp{4,6}_get_mtu() lead to overlength frames in transport mode for
> certain mtu values and suboptimal frames for others.
> 
> According to what is done, mainly in esp{,6}_output() and tcp_mtu_to_mss(),
> net_header_len must be taken into account before doing the alignment
> calculation.
> 
> Signed-off-by: Benjamin Poirier <bpoirier@suse.de>

Applied and queued up for -stable, thanks.
