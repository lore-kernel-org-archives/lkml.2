Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431Ab0KEFUL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 01:20:11 -0400
Received: from avexcashub1.qlogic.com ([198.70.193.61]:58327 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848Ab0KEFUJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 01:20:09 -0400
From: Amit Salecha <amit.salecha@qlogic.com>
To: Joe Perches <joe@perches.com>, Jiri Kosina <trivial@kernel.org>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 5 Nov 2010 00:18:30 -0500
Subject: RE: [PATCH 27/49] drivers/net/netxen: Use vzalloc
Thread-Topic: [PATCH 27/49] drivers/net/netxen: Use vzalloc
Thread-Index: Act8lsnGDPVuWNqiTYKIVO0ZWif+SQAEhjdG
Message-ID: <99737F4847ED0A48AECC9F4A1974A4B80FCEAB4368@MNEXMB2.qlogic.org>
References: <cover.1288925424.git.joe@perches.com>,<61bf7e82bb35693aebdb3a56b30b1c38836bf502.1288925425.git.joe@perches.com>
In-Reply-To: <61bf7e82bb35693aebdb3a56b30b1c38836bf502.1288925425.git.joe@perches.com>
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

> From: Joe Perches [joe@perches.com]
> Sent: Friday, November 05, 2010 8:37 AM
> To: Jiri Kosina
> Cc: Amit Salecha; netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCH 27/49] drivers/net/netxen: Use vzalloc
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
> drivers/net/netxen/netxen_nic_init.c |    7 ++-----
>  files changed, 2 insertions(+), 5 deletions(-)

Thanks.