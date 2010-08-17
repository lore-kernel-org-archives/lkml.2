Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231Ab0HQI66 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 04:58:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:7103 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756649Ab0HQI65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 04:58:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,381,1278313200"; 
   d="scan'208";a="546040001"
Date: Tue, 17 Aug 2010 09:21:20 +0100
From: Alan Cox <alan@linux.intel.com>
To: Michal Simek <monstr@monstr.eu>
Cc: michal.simek@petalogix.com, Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        Lytochkin Boris <lytboris@gmail.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] serial: 8250pci: Recast inb return value
Message-ID: <20100817092120.79b87813@linux.intel.com>
In-Reply-To: <1282031947-16483-2-git-send-email-monstr@monstr.eu>
References: <1282031947-16483-1-git-send-email-monstr@monstr.eu>
	<1282031947-16483-2-git-send-email-monstr@monstr.eu>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Aug 2010 09:59:07 +0200
Michal Simek <monstr@monstr.eu> wrote:

> inb returns u8 that's why is necessary to do recast.
> 
> Compilation warning:
>   CC      drivers/serial/8250_pci.o
> drivers/serial/8250_pci.c: In function 'pci_ite887x_init':
> drivers/serial/8250_pci.c:825: warning: cast to pointer from integer

NAK - this makes no sense at all
