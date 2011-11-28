Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295Ab1K1Lf0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 06:35:26 -0500
Received: from mga01.intel.com ([192.55.52.88]:28202 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752464Ab1K1LfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 06:35:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,583,1315206000"; 
   d="scan'208";a="96006143"
Date: Mon, 28 Nov 2011 11:46:49 +0000
From: Alan Cox <alan@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Arnd Bergmann <arnd@arndb.de>, Jamie Iles <jamie@jamieiles.com>,
        Yoichi Yuasa <yuasa@linux-mips.org>, linux-serial@vger.kernel.org
Subject: Re: [PATCH] TTY: serial: convert drivers/tty/serial/* to use
 module_platform_driver()
Message-ID: <20111128114649.4ce362c7@bob.linux.org.uk>
In-Reply-To: <1322479335.1939.6.camel@phoenix>
References: <1322479335.1939.6.camel@phoenix>
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

On Mon, 28 Nov 2011 19:22:15 +0800
Axel Lin <axel.lin@gmail.com> wrote:

> This patch converts the drivers in drivers/tty/serial/* to use the
> module_platform_driver() macro which makes the code smaller and a bit
> simpler.

Acked-by: Alan Cox <alan@linux.intel.com>
