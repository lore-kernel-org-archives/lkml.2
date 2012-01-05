Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727Ab2AEMcL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 07:32:11 -0500
Received: from mga14.intel.com ([143.182.124.37]:7548 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755248Ab2AEMcJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 07:32:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="92665339"
Date: Thu, 5 Jan 2012 12:45:05 +0000
From: Alan Cox <alan@linux.intel.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Greg KH <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH] serial: relocate remaining serial drivers from tty/ to
 tty/serial/
Message-ID: <20120105124505.73c88f2c@bob.linux.org.uk>
In-Reply-To: <20120105054240.GA9093@merkur.ravnborg.org>
References: <1325707287-31038-1-git-send-email-paul.gortmaker@windriver.com>
	<4F04BFA8.9010100@windriver.com>
	<20120104220332.GA22985@suse.de>
	<201201042327.33739.arnd@arndb.de>
	<20120105054240.GA9093@merkur.ravnborg.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> drivers/tty/serial_core  <= drivers based on SERIAL_CORE
> drivers/tty/serial       <= the rest
> 
> This makes it obvious that one directory is for drivers based on
> SERIAL_CORE - and the other is sort of the "rest".
> 
> I know this imply moving files around again :-(

And putting one lot where the other were. Merge time is closed so we've
got plenty of time to sort this right. For the moment can we just tidy
up 8250, then think about it in more detail rather than play musical
chairs ?

Alan
