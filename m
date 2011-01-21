Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370Ab1AUQJl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 11:09:41 -0500
Received: from www.tglx.de ([62.245.132.106]:49847 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753584Ab1AUQJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 11:09:40 -0500
Date: Fri, 21 Jan 2011 17:09:31 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
cc: John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] acpi_pm: Clear pmtmr_ioport if acpi_pm initialization
 fails
In-Reply-To: <20110121145008.GC27319@dumpdata.com>
Message-ID: <alpine.LFD.2.00.1101211709100.2971@localhost6.localdomain6>
References: <1295027246-11110-1-git-send-email-johnstul@us.ibm.com> <20110121145008.GC27319@dumpdata.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Jan 2011, Konrad Rzeszutek Wilk wrote:

> On Fri, Jan 14, 2011 at 09:47:26AM -0800, John Stultz wrote:
> > From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > 
> 
> tgl,
> 
> Are you OK pushing this up to Linus or should I do it? We can
> also delay this till the next merge window as the other fix
> that John proposed solves the bootup issue so it is not that urgent.

It's in my queue, no worry.
