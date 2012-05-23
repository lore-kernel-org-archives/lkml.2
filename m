Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933773Ab2EWRov (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 13:44:51 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:60456 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760655Ab2EWRou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 13:44:50 -0400
Date: Wed, 23 May 2012 13:41:34 -0400 (EDT)
Message-Id: <20120523.134134.1083024931902332575.davem@davemloft.net>
To: michel@digirati.com.br
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kuznet@ms2.inr.ac.ru,
        jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net,
        edumazet@google.com, jpirko@redhat.com, mirq-linux@rere.qmqm.pl,
        bhutchings@solarflare.com
Subject: Re: [PATCH 1/1] net: add dev_loopback_xmit() to avoid duplicate
 code
From: David Miller <davem@davemloft.net>
In-Reply-To: <1337782819.2779.20.camel@Thor>
References: <1337782819.2779.20.camel@Thor>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 23 May 2012 10:41:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'm getting really tired of saying this.

As I announced several days ago, it is absolutely not appropriate
to submit patches other than bug fixes at this time because we are
in the merge window and the net-next tree is frozen.

And even once I do announce here that the net-next tree is open
once more, and patches like this one are appropriate, you must
indicate in the subject line which of the 'net' or 'net-next'
tree you are targetting your patch at.

Please pay attention to what's going on, and what state the networking
development trees are in, before submitting changes.
