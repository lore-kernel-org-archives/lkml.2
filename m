Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594Ab0KZMPu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 07:15:50 -0500
Received: from casper.infradead.org ([85.118.1.10]:49413 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880Ab0KZMPt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 07:15:49 -0500
Subject: Re: [patch 1/3] printk: fix wake_up_klogd() vs cpu hotplug
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org,
        Christof Schmitt <christof.schmitt@de.ibm.com>,
        Frank Blaschka <frank.blaschka@de.ibm.com>,
        Horst Hartmann <horsth@linux.vnet.ibm.com>
In-Reply-To: <20101126121325.GA7023@osiris.boeblingen.de.ibm.com>
References: <20101126120057.879397696@de.ibm.com>
	 <20101126120235.091835714@de.ibm.com> <1290773408.2145.138.camel@laptop>
	 <20101126121325.GA7023@osiris.boeblingen.de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 26 Nov 2010 13:15:25 +0100
Message-ID: <1290773725.2145.141.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-26 at 13:13 +0100, Heiko Carstens wrote:
> > But but but, the cpu can still be offlined between writing this state
> > and the next tick happening, right?
> 
> Yes, that's what the second patch would fix as a side effect. 

Ah, right, ok took them both.
