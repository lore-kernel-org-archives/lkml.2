Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934089Ab2FHQFA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 12:05:00 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48095 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932609Ab2FHQE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 12:04:58 -0400
Subject: Re: Deadlock, L2TP over IP are not working, 3.4.1
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Denys Fedoryshchenko <denys@visp.net.lb>
Cc: Benjamin LaHaise <bcrl@kvack.org>, Francois Romieu <romieu@fr.zoreil.com>,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <67d8beaf421874815145fdefc69b3366@visp.net.lb>
References: <7ed49f446365ac625437702d92946add@visp.net.lb>
	 <20120607205356.GA2491@electric-eye.fr.zoreil.com>
	 <1339104606.6001.4.camel@edumazet-glaptop>
	 <20120607223752.GA4475@electric-eye.fr.zoreil.com>
	 <1339134438.6001.13.camel@edumazet-glaptop>
	 <20120608154106.GD5024@kvack.org>
	 <67d8beaf421874815145fdefc69b3366@visp.net.lb>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Jun 2012 18:04:55 +0200
Message-ID: <1339171495.6001.118.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-08 at 18:56 +0300, Denys Fedoryshchenko wrote:

> Right now i am routing around 700Mbps over there, and noticed some 
> problem with pskb_expand_head,
> but that's separate question i will ask, if i will not be able to sort 
> it out by myself.
> 

Before spending too much time on this, make sure you use a kernel
including commit 617c8c11236 ( skb: avoid unnecessary reallocations in
__skb_cow )



