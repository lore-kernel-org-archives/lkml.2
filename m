Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599Ab2G3PMq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 11:12:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:24238 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754188Ab2G3PMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 11:12:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="199990456"
Date: Mon, 30 Jul 2012 23:07:47 +0800
From: Feng Tang <feng.tang@intel.com>
To: <paulmck@linux.vnet.ibm.com>
Cc: "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Len Brown <len.brown@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mail List <linux-kernel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [Regression 3.4] tick_broadcast_mask is not restored after a
 CPU has been offline/onlined
Message-ID: <20120730230747.7637112a@feng-i7>
In-Reply-To: <20120730133913.GK2556@linux.vnet.ibm.com>
References: <20120730151559.772d4055@feng-i7>
	<20120730133913.GK2556@linux.vnet.ibm.com>
Organization: intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Mon, 30 Jul 2012 06:39:13 -0700
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> On Mon, Jul 30, 2012 at 03:15:59PM +0800, Feng Tang wrote:
> > Hi All,
> > 
> > When I debugged a suspend/resume bug, I found that tick_broadcast_mask is
> > not restored for a CPU after it is offline/onlined since kernel 3.4, while
> > it's fine for 3.3.
> 
> Could you please try 3.5?

Yes, it's the same for 3.5

Thanks,
Feng
