Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758894Ab1KVW5J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 17:57:09 -0500
Received: from mga11.intel.com ([192.55.52.93]:35668 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752334Ab1KVW5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 17:57:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,556,1315206000"; 
   d="scan'208";a="88301285"
Date: Tue, 22 Nov 2011 23:08:40 +0000
From: Alan Cox <alan@linux.intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH v3 0/2] KT serial controller IIR workaround
Message-ID: <20111122230840.72f602b2@bob.linux.org.uk>
In-Reply-To: <20111122213859.13786.7738.stgit@localhost6.localdomain6>
References: <20111122213859.13786.7738.stgit@localhost6.localdomain6>
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

On Tue, 22 Nov 2011 13:41:19 -0800
Dan Williams <dan.j.williams@intel.com> wrote:

> Changes since v2 [1]:
> * reflowed on tty-next (commit: 161e773c "UART: add CSR
> SiRFprimaII..."
> * add a quirk to turn on msi to try to prevent shared interrupts
> 
> [1]: https://lkml.org/lkml/2011/11/15/264
> 
> ---
> 
> Dan Williams (2):
>       serial/8250_pci: setup-quirk workaround for the kt serial
> controller serial/8250_pci: init-quirk msi support for kt serial
> controller

Series

Acked-by: Alan Cox <alan@linux.intel.com>
