Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932300Ab0HQIzG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 04:55:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:2321 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756486Ab0HQIzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 04:55:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,381,1278313200"; 
   d="scan'208";a="648485626"
Date: Tue, 17 Aug 2010 09:17:20 +0100
From: Alan Cox <alan@linux.intel.com>
To: Michal Simek <monstr@monstr.eu>
Cc: michal.simek@petalogix.com, Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Manuel Lauss <manuel.lauss@googlemail.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] serial: 8250: Initialize pointer to irq_info
Message-ID: <20100817091720.56183993@linux.intel.com>
In-Reply-To: <1282031947-16483-1-git-send-email-monstr@monstr.eu>
References: <1282031947-16483-1-git-send-email-monstr@monstr.eu>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Aug 2010 09:59:06 +0200
Michal Simek <monstr@monstr.eu> wrote:

> Initialize "i" irq_info pointer in serial_unlink_irq_chain.
> 
> Compilation warning:
>   CC      drivers/serial/8250.o
> drivers/serial/8250.c: In function 'serial8250_shutdown':
> drivers/serial/8250.c:1701: warning: 'i' may be used uninitialized in
> this function

NAK (again)

Use a newer compiler - modern ones get this right.
