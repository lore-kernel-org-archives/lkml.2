Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758919Ab2IMWLx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 18:11:53 -0400
Received: from gate.crashing.org ([63.228.1.57]:56546 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752023Ab2IMWLv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 18:11:51 -0400
Message-ID: <1347574295.2276.34.camel@pasglop>
Subject: Re: [PATCH] powerpc/smp: Do not disable IPI interrupts during
 suspend
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: "linuxppc-dev@lists.ozlabs.org list" <linuxppc-dev@lists.ozlabs.org>,
        Zhao Chenhui <chenhui.zhao@freescale.com>,
        "linux-kernel@vger.kernel.org list" <linux-kernel@vger.kernel.org>
Date: Fri, 14 Sep 2012 08:11:35 +1000
In-Reply-To: <287921FF-96B1-4BBC-B9F9-3F8D24244061@kernel.crashing.org>
References: <1342788421-27648-1-git-send-email-chenhui.zhao@freescale.com>
	 <5028672F-1873-4E45-AA23-4CA9F191BE77@kernel.crashing.org>
	 <1343427631.21647.1.camel@pasglop>
	 <20120802100418.GA13777@localhost.localdomain>
	 <1C2FF4B5-3F3C-4A9D-941D-A4BC4F5C95DE@kernel.crashing.org>
	 <287921FF-96B1-4BBC-B9F9-3F8D24244061@kernel.crashing.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-13 at 13:16 -0500, Kumar Gala wrote:
> >> Yes, we disabled all non-boot CPUs on suspend by calling
> disable_nonboot_cpus().
> >> The disable_nonboot_cpus() needs IPIs to work. But prior to
> >> calling disable_nonboot_cpus(), the IPIs are disabled in
> dpm_suspend_noirq().

Sure, no biggie on this one, forgot to ack it, just stick my ack in and
put it in your tree.

Cheers,
Ben.


