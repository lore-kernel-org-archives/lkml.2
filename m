Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758845Ab2FZRQv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 13:16:51 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33718 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758499Ab2FZRQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 13:16:49 -0400
Date: Tue, 26 Jun 2012 18:16:33 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: Tejun Heo <tj@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Doug Anderson <dianders@chromium.org>
Subject: Re: try_to_freeze() called with IRQs disabled on ARM
Message-ID: <20120626171632.GA22977@n2100.arm.linux.org.uk>
References: <20110823221314.GL3895@n2100.arm.linux.org.uk> <CAOS58YNtQEuke=Ko9J2oNGMECjabzxj=Nrg1o64X1JC3YRmJuw@mail.gmail.com> <20110825121416.GB8883@n2100.arm.linux.org.uk> <20110825121710.GK3286@htj.dyndns.org> <20110825122543.GC8883@n2100.arm.linux.org.uk> <20110825123542.GM3286@htj.dyndns.org> <20110825130414.GE8883@n2100.arm.linux.org.uk> <20110825130907.GO3286@htj.dyndns.org> <20110825145558.GF8883@n2100.arm.linux.org.uk> <CACBanvqp52q0c6SxsSFqZwfn45Knt-CYgg-AcOJrtaQ-Lim+YQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACBanvqp52q0c6SxsSFqZwfn45Knt-CYgg-AcOJrtaQ-Lim+YQ@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2012 at 09:39:14AM -0700, Mandeep Singh Baines wrote:
> Hi Russell,
> 
> We are seeing this on ARM with a 3.4 kernel. How was it eventually
> resolved? This patch isn't in any tree and I can't find any patch in
> linus/master or in any ARM tree that looks like it fixes this.

It's still work in progress.
