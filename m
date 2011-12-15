Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758774Ab1LOKKv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 05:10:51 -0500
Received: from mga03.intel.com ([143.182.124.21]:52992 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753065Ab1LOKKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 05:10:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="47477900"
Date: Thu, 15 Dec 2011 10:22:30 +0000
From: Alan Cox <alan@linux.intel.com>
To: Claudio Scordino <claudio@evidence.eu.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Dave Bender <codehero@gmail.com>
Subject: Re: [PATCH] atmel_serial: fix spinlock lockup in RS485 code
Message-ID: <20111215102230.70ca7011@bob.linux.org.uk>
In-Reply-To: <4EE9B42F.50004@evidence.eu.com>
References: <4EE9B42F.50004@evidence.eu.com>
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

On Thu, 15 Dec 2011 09:47:43 +0100
Claudio Scordino <claudio@evidence.eu.com> wrote:

> Subject: atmel_serial: fix spinlock lockup in RS485 code
> 
> Patch to fix a spinlock lockup in the driver that sometimes happens
> when the tasklet starts.
> 
> Signed-off-by: Claudio Scordino <claudio@evidence.eu.com>
> Signed-off-by: Dave Bender <codehero@gmail.com>
> Tested-by: Dave Bender <codehero@gmail.com>

Acked-by: Alan Cox <alan@linux.intel.com>
