Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751541Ab1FAMyB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 08:54:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:2522 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128Ab1FAMx7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 08:53:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,303,1304319600"; 
   d="scan'208";a="7826506"
Date: Wed, 1 Jun 2011 13:41:07 +0100
From: Alan Cox <alan@linux.intel.com>
To: =?ISO-8859-14?B?RnLpZOlyaWMgQnJp6HJl?= <fbriere@fbriere.net>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-serial@vger.kernel.org, linux-parport@lists.infradead.org
Subject: Re: [PATCH 2/2] parport/serial: add support for Timedia/SUNIX cards
 to parport_serial
Message-ID: <20110601134107.74e4dbf7@bob.linux.org.uk>
In-Reply-To: <1306696084-17977-2-git-send-email-fbriere@fbriere.net>
References: <1306696084-17977-1-git-send-email-fbriere@fbriere.net>
	<1306696084-17977-2-git-send-email-fbriere@fbriere.net>
Organization: Intel
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 May 2011 15:08:04 -0400
Frédéric Brière <fbriere@fbriere.net> wrote:

> Timedia/SUNIX PCI cards with both serial and parallel ports are
> currently supported by 8250_pci and parport_pc individually.  Moving
> that support into parport_serial allows using both types of ports at
> the same time.
> 
> This was successfully tested with a SUNIX 4079T.
> 
> Signed-off-by: Frédéric Brière <fbriere@fbriere.net>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: Alan Cox <alan@linux.intel.com>
> Cc: linux-serial@vger.kernel.org
> Cc: linux-parport@lists.infradead.org

Acked-by: Alan Cox <alan@linux.intel.com>
