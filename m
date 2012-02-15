Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab2BOUkA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 15:40:00 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:60471 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755279Ab2BOUj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 15:39:57 -0500
Date: Wed, 15 Feb 2012 15:34:45 -0500 (EST)
Message-Id: <20120215.153445.1279062916210043775.davem@davemloft.net>
To: danny.kukawka@bisect.de
Cc: dkukawka@suse.de, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, nicolas.ferre@atmel.com,
        hsweeten@visionengravers.com, florian@openwrt.org, venza@brownhat.org,
        steve.glendinning@smsc.com, peppe.cavallaro@st.com, rl@hellgate.ch,
        gregkh@linuxfoundation.org, rusty@rustcorp.com.au, mst@redhat.com,
        khc@pm.waw.pl, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v2 1/2] net: replace random_ether_addr() with
 eth_hw_addr_random()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1329324340-13461-2-git-send-email-danny.kukawka@bisect.de>
References: <1329324340-13461-1-git-send-email-danny.kukawka@bisect.de>
	<1329324340-13461-2-git-send-email-danny.kukawka@bisect.de>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 15 Feb 2012 12:34:53 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Danny Kukawka <danny.kukawka@bisect.de>
Date: Wed, 15 Feb 2012 17:45:39 +0100

> Replace usage of random_ether_addr() with eth_hw_addr_random()
> to set addr_assign_type correctly to NET_ADDR_RANDOM.
> 
> Change the trivial cases.
> 
> v2: adapt to renamed eth_hw_addr_random()
> 
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>

Applied.
