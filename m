Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab1JSXkc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 19:40:32 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:51153 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731Ab1JSXka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 19:40:30 -0400
Date: Wed, 19 Oct 2011 19:38:16 -0400 (EDT)
Message-Id: <20111019.193816.1914930895184608328.davem@davemloft.net>
To: krkumar2@in.ibm.com
Cc: Ian.Campbell@citrix.com, linux-kernel@vger.kernel.org, mst@redhat.com,
        netdev@vger.kernel.org, rusty@rustcorp.com.au,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] Fix guest memory leak and panic
From: David Miller <davem@davemloft.net>
In-Reply-To: <OFF565DE9F.92BF6FE5-ON6525792D.00488336-6525792D.00494D56@in.ibm.com>
References: <OFB632D60B.6534A38B-ON6525792D.003A1B21-6525792D.003B0DB8@in.ibm.com>
	<1318935055.3385.0.camel@zakaz.uk.xensource.com>
	<OFF565DE9F.92BF6FE5-ON6525792D.00488336-6525792D.00494D56@in.ibm.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 19 Oct 2011 16:38:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Krishna could you please respin your original patch, fixing the subject
and adjusting the commit message to indicate this is a cleanup.

Assume I have applied Ian's patch, because that's what I'm about to
do.

Thanks!
