Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab2J2JuH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 05:50:07 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:65013 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753292Ab2J2JuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 05:50:04 -0400
Message-ID: <1351504201.1339.4.camel@x61.thuisdomein>
Subject: Re: [PATCH] IB/lmx4: silence GCC warning
From: Paul Bolle <pebolle@tiscali.nl>
To: Jack Morgenstein <jackm@dev.mellanox.co.il>
Cc: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 29 Oct 2012 10:50:01 +0100
In-Reply-To: <201210100923.43927.jackm@dev.mellanox.co.il>
References: <1348836538.3626.21.camel@x61.thuisdomein>
	 <201210100923.43927.jackm@dev.mellanox.co.il>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Oct 2012 09:50:02.0388 (UTC) FILETIME=[C433B540:01CDB5BA]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-10 at 09:23 +0200, Jack Morgenstein wrote:
> You could use:
> 
>    u16 uninitialized_var(vlan);
> 
> instead.

I guess we'd better just wait and see whether uninitialized_var()
survives before discussing your suggestion (see the thread starting at
https://lkml.org/lkml/2012/10/26/508 ).

> Although this in the special QP data flow, I still prefer to avoid adding extra code (even setting
> initial values at procedure entry).  The line above will also do the job.  "uninitialized_var"
> is used elsewhere in the driver.  See, for example, mlx4_ib_post_send() in the same file (qp.c).


Paul Bolle

