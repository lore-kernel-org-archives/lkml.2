Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799Ab2F2LUl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 07:20:41 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753375Ab2F2LUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 07:20:40 -0400
Date: Fri, 29 Jun 2012 13:20:35 +0200
From: Richard Weinberger <richard@nod.at>
To: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        <Heinz.Egger@linutronix.de>, thomas.wucher@linutronix.de,
        tglx@linutronix.de, tim.bird@am.sony.com, Marius.Mazarel@ugal.ro,
        nyoushchenko@mvista.com, linux-mtd@lists.infradead.org
Subject: Re: [PATCH] ubi: fastmap: Do not free 'ai' in 'scan_all()'
Message-ID: <20120629132035.1428ca01@spider.haslach.nod.at>
In-Reply-To: <20120628174546.491954e2@pixies.home.jungo.com>
References: <20120628165239.52cffc64@pixies.home.jungo.com>
	<20120628174546.491954e2@pixies.home.jungo.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Thu, 28 Jun 2012 17:45:46 +0300
schrieb Shmulik Ladkani <shmulik.ladkani@gmail.com>:

> From: Shmulik Ladkani <shmulik.ladkani@gmail.com>
> 
> Do not call 'destroy_ai(ai)' at error handling of 'scan_all', since:
> - 'ai' is allocated in 'ubi_attach' (the caller of scan_all) and
>   provided as an argument. It's not scan_all's responsibility to free
> it
> - It is not consistent with scan_all's sister function
>   'ubi_attach_fastmap()' which does not free the given 'ai'
> - It will cause a double free as 'ubi_attach' (the caller of scan_all)
>   already destroys 'ai' in case of an error
> 
> Signed-off-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
> ---

Applied!

Thanks,
//richard
