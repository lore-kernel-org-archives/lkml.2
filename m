Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785Ab1HPSU0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 14:20:26 -0400
Received: from mga11.intel.com ([192.55.52.93]:13204 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752238Ab1HPSUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 14:20:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,234,1312182000"; 
   d="scan'208";a="40172367"
Date: Tue, 16 Aug 2011 19:24:38 +0100
From: Alan Cox <alan@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Jeff Chua <jeff.chua.linux@gmail.com>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH] serial: 8250_pnp: add Intermec CV60 touchscreen device
Message-ID: <20110816192438.1bb11fac@bob.linux.org.uk>
In-Reply-To: <20110816180228.13152.61387.stgit@bhelgaas.mtv.corp.google.com>
References: <20110816180228.13152.61387.stgit@bhelgaas.mtv.corp.google.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Aug 2011 12:02:28 -0600
Bjorn Helgaas <bhelgaas@google.com> wrote:

> It would have been nice if Intermec had supplied a PNP0501 _CID for
> the COM3 device, but they didn't, so we have to recognize it
> explicitly.

Acked-by: Alan Cox <alan@linux.intel.com>
