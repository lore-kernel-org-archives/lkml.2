Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759979Ab1LPAdo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 19:33:44 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:43564 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756418Ab1LPAdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 19:33:42 -0500
Message-ID: <1323995620.18603.4.camel@joe2Laptop>
Subject: Re: [PATCH 14/15] module_param: make bool parameters really bool
 (net & drivers/net)
From: Joe Perches <joe@perches.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Date: Thu, 15 Dec 2011 16:33:40 -0800
In-Reply-To: <87k45xqvfs.fsf@rustcorp.com.au>
References: <877h1ysenl.fsf@rustcorp.com.au>
	 <1323920752.29500.11.camel@joe2Laptop> <87k45xqvfs.fsf@rustcorp.com.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-16 at 09:44 +1030, Rusty Russell wrote:
> I could, but as I was touching 457 files, so I was aiming for minimal
> changes.

> Dave, did you want a true/false cleanup too?

Hi Rusty.

Did you perform these transforms via spatch?
If not, here's a trivial spatch script for those files.

$ cat bool.cocci
@@
bool b
@@
-b = 0
+b = false
@@
bool b
@@
-b = 1
+b = true



