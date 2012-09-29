Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759164Ab2I2ARw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 20:17:52 -0400
Received: from imr4.ericy.com ([198.24.6.9]:55698 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758829Ab2I2ARv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 20:17:51 -0400
From: Ramesh Nagappa <ramesh.nagappa@ericsson.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "michel@digirati.com.br" <michel@digirati.com.br>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>
Date: Fri, 28 Sep 2012 20:17:37 -0400
Subject: RE: [PATCH] net: fix neigh_resolve_output can cause skb_under_panic
Thread-Topic: [PATCH] net: fix neigh_resolve_output can cause skb_under_panic
Thread-Index: Ac2d1Ekch7yQm/siSV6TrUV8ePFHuAAAvnfQ
Message-ID: <CA3E5132752D1F49871ED0FC40D56BBA43ECE2E741@EUSAACMS0701.eamcs.ericsson.se>
References: <CA3E5132752D1F49871ED0FC40D56BBA43ECE2E72D@EUSAACMS0701.eamcs.ericsson.se>
 <20120928235209.GA11474@kroah.com>
In-Reply-To: <20120928235209.GA11474@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, Outlook managled the patch. I will try to find a way to re-submit it.

> 
> You need a blank line before the first Signed-off-by: line.  
> Surely one of the reviewers should have caught this basic thing?
> 
> greg k-h
> 

-- Ramesh