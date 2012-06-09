Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751495Ab2FIKnN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 06:43:13 -0400
Received: from mga14.intel.com ([143.182.124.37]:6073 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884Ab2FIKnM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 06:43:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="110021131"
Date: Sat, 9 Jun 2012 11:59:02 +0100
From: Alan Cox <alan@linux.intel.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] serial: fix kernel-doc warnings in 8250.c
Message-ID: <20120609115902.65fe131e@bob.linux.org.uk>
In-Reply-To: <4FD2AC1B.6070500@xenotime.net>
References: <4FD2AC1B.6070500@xenotime.net>
Organization: Intel
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 08 Jun 2012 18:51:23 -0700
Randy Dunlap <rdunlap@xenotime.net> wrote:

> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> Fix kernel-doc warnings in drivers/tty/serial/8250/8250.c:
> 
> Warning(drivers/tty/serial/8250/8250.c:3128): No description found
> for parameter 'up' Warning(drivers/tty/serial/8250/8250.c:3128):
> Excess function parameter 'port' description in
> 'serial8250_register_8250_port'
> 
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>

Acked-by: Alan Cox <alan@linux.intel.com>
