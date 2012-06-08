Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761412Ab2FHPlK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 11:41:10 -0400
Received: from kanga.kvack.org ([205.233.56.17]:35597 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761323Ab2FHPlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 11:41:08 -0400
Date: Fri, 8 Jun 2012 11:41:06 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Francois Romieu <romieu@fr.zoreil.com>,
        Denys Fedoryshchenko <denys@visp.net.lb>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Deadlock, L2TP over IP are not working, 3.4.1
Message-ID: <20120608154106.GD5024@kvack.org>
References: <7ed49f446365ac625437702d92946add@visp.net.lb> <20120607205356.GA2491@electric-eye.fr.zoreil.com> <1339104606.6001.4.camel@edumazet-glaptop> <20120607223752.GA4475@electric-eye.fr.zoreil.com> <1339134438.6001.13.camel@edumazet-glaptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339134438.6001.13.camel@edumazet-glaptop>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2012 at 07:47:18AM +0200, Eric Dumazet wrote:
> I have no idea how many l2tp_eth devices are setup at once in typical
> conf.

Depends on the usage scenario.  L2TP is commonly used for terminating 
customer connections by wholesale ISPs.  In that kind of edge routing 
use-case, tens of thousands of interfaces are easily possible.

		-ben
-- 
"Thought is the essence of where you are now."
