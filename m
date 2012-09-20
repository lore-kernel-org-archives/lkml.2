Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695Ab2ITBkp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 21:40:45 -0400
Received: from server505a.appriver.com ([98.129.35.4]:1919 "EHLO
	server505.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751444Ab2ITBkn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 21:40:43 -0400
X-Note-AR-ScanTimeLocal: 9/19/2012 8:40:42 PM
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Policy: Too many policies to list
X-Primary: ecashin@coraid.com
X-Note: This Email was scanned by AppRiver SecureTide
X-ALLOW: @coraid.com ALLOWED
X-Virus-Scan: V-
X-Note: Spam Tests Failed: 
X-Country-Path: UNKNOWN->UNITED STATES->UNITED STATES
X-Note-Sending-IP: 98.129.35.1
X-Note-Reverse-DNS: smtp.exg5.exghost.com
X-Note-Return-Path: ecashin@coraid.com
X-Note: User Rule Hits: 
X-Note: Global Rule Hits: G299 G300 G301 G302 G306 G307 G318 G411 
X-Note: Encrypt Rule Hits: 
X-Note: Mail Class: ALLOWEDSENDER
X-Note: Headers Injected
From: Ed Cashin <ecashin@coraid.com>
To: Ben Hutchings <bhutchings@solarflare.com>
CC: "davem@davemloft.net" <davem@davemloft.net>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "jesse@nicira.com" <jesse@nicira.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 19 Sep 2012 20:40:40 -0500
Subject: Re: [PATCH 1/2] aoe: mark AoE packets as requiring no checksumming
Thread-Topic: [PATCH 1/2] aoe: mark AoE packets as requiring no checksumming
Thread-Index: Ac2W0PF4/yTaZQr/Ssa+Q5S+U+FbSA==
Message-ID: <4DD17064-F075-48D0-8C3D-EFF6C043BA50@coraid.com>
References: <1348079358.4585@cat.he.net>
 <cover.1348088283.git.ecashin@coraid.com>
 <72368962c6414543ce7d2c3f1ab5f36154fdd710.1348088283.git.ecashin@coraid.com>
 <1348104303.4836.63.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1348104303.4836.63.camel@deadeye.wl.decadent.org.uk>
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

On Sep 19, 2012, at 9:25 PM, Ben Hutchings wrote:

> Can be written as:
> 		skb_checksum_none_assert(skb);

Another good idea.  I'll resend.

-- 
  Ed Cashin
  ecashin@coraid.com


