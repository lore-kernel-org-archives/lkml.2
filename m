Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264Ab2HCIjp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 04:39:45 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:38858 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987Ab2HCIjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 04:39:42 -0400
Date: Fri, 3 Aug 2012 09:24:30 +0200
From: Harald Welte <laforge@gnumonks.org>
To: Silas Boyd-Wickizer <sbw@mit.edu>
Cc: linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jean Delvare <khali@linux-fr.org>, Guenter Roeck <linux@roeck-us.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Harald Welte <laforge@openezx.org>, x86@kernel.org
Subject: Re: [PATCH 3/3] Use get_online_cpus to avoid races involving
 for_each_online_cpu
Message-ID: <20120803072430.GL16661@prithivi.gnumonks.org>
References: <20120803000708.GD3443@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120803000708.GD3443@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Silas,

thanks a lot for the finding and addressing the issue.

On Thu, Aug 02, 2012 at 05:07:08PM -0700, Silas Boyd-Wickizer wrote:
> Signed-off-by: Silas Boyd-Wickizer <sbw@mit.edu>

Acked-by: Harald Welte <laforge@gnumonks.org>

-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
