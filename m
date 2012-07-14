Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041Ab2GNT3V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 15:29:21 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52287 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab2GNT3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 15:29:14 -0400
Date: Sat, 14 Jul 2012 12:29:13 -0700 (PDT)
Message-Id: <20120714.122913.1391783610681090477.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: a9702387@unet.univie.ac.at, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: resurrecting tcphealth
From: David Miller <davem@davemloft.net>
In-Reply-To: <1342254423.3265.9028.camel@edumazet-glaptop>
References: <cc6495b92f1df180c1ad43057ceb0b98.squirrel@webmail.univie.ac.at>
	<1342254423.3265.9028.camel@edumazet-glaptop>
X-Mailer: Mew version 6.5 on Emacs 24.0.97 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Don't we report all of this shit in tcp_info already?

I really hate such cruddy patches like this.
