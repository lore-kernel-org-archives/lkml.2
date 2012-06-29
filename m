Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245Ab2F2LU1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 07:20:27 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751815Ab2F2LU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 07:20:26 -0400
Date: Fri, 29 Jun 2012 13:20:11 +0200
From: Richard Weinberger <richard@nod.at>
To: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        <Heinz.Egger@linutronix.de>, thomas.wucher@linutronix.de,
        tglx@linutronix.de, tim.bird@am.sony.com, Marius.Mazarel@ugal.ro,
        nyoushchenko@mvista.com, linux-mtd@lists.infradead.org
Subject: Re: [PATCH] ubi: fastmap: Remove 'ubi' parameter of 'destroy_ai()'
Message-ID: <20120629132011.3f53ca86@spider.haslach.nod.at>
In-Reply-To: <20120628165239.52cffc64@pixies.home.jungo.com>
References: <20120628165239.52cffc64@pixies.home.jungo.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Thu, 28 Jun 2012 16:52:39 +0300
schrieb Shmulik Ladkani <shmulik.ladkani@gmail.com>:

> From: Shmulik Ladkani <shmulik.ladkani@gmail.com>
> 
> The 'ubi' argument of 'destroy_ai' was added during fastmap
> development, but it is no longer used.
> 
> Signed-off-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
> ---

Applied!

Thanks,
//richard
