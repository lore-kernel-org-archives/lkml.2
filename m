Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751635Ab2ISUOm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 16:14:42 -0400
Received: from server505e.appriver.com ([98.129.35.9]:1027 "EHLO
	server505.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751342Ab2ISUOk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 16:14:40 -0400
X-Note-AR-ScanTimeLocal: 9/19/2012 3:14:38 PM
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
To: David Miller <davem@davemloft.net>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "jesse@nicira.com" <jesse@nicira.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 19 Sep 2012 15:14:31 -0500
Subject: Re: [PATCH] net: do not disable sg for AoE
Thread-Topic: [PATCH] net: do not disable sg for AoE
Thread-Index: Ac2Wo2GLxQsSWi8ASTSsFwYNy43D5w==
Message-ID: <54341AB7-E6F1-4877-8CE1-D581EA79F6E5@coraid.com>
References: <1348079358.4585@cat.he.net>
 <20120919.160009.1489407274317336389.davem@davemloft.net>
In-Reply-To: <20120919.160009.1489407274317336389.davem@davemloft.net>
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

On Sep 19, 2012, at 4:00 PM, David Miller wrote:

> Please do not incorporate the date of the commit in your local tree
> into the Date: field advertised in your outgoing emails when you post
> patches.

Noted.   I will remove the Date field added by git-format-patch from now on.

Sorry for the inconvenience.

-- 
  Ed Cashin
  ecashin@coraid.com


