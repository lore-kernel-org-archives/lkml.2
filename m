Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014Ab2LBRft (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 12:35:49 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:39134 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814Ab2LBRfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 12:35:47 -0500
Date: Sun, 2 Dec 2012 20:35:18 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Russ Anderson <rja@sgi.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        walter harms <wharms@bfs.de>
Subject: Re: [patch v3] x86, UV: integer wrap bug in uv_hub_ipi_value()
Message-ID: <20121202173517.GB6568@mwanda>
References: <50BB74E7.9060306@bfs.de>
 <20121202172842.GA20110@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121202172842.GA20110@elgon.mountain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 02, 2012 at 08:28:43PM +0300, Dan Carpenter wrote:
> This is a static checker fix.  The problem is that we store the bits
> from "uv_apicid_hibits" into "apicid" (the high 16 bits) but then we
> shift it 16 bit to the left.  "apicid" is an int so it wraps and we lose
> them.
> 
> I have also simplified uv_wakeup_secondary() a little based on a
> suggestion.

This was supposed to say "suggestions from Walter Harms." but I
pressed "u" in vim instead of "i" because they are next to each
other so that that got deleted.  @%$@#$%@%$.  I'll resend.

regards,
dan carpenter

