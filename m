Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab2JCMgJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 08:36:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:49528 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752650Ab2JCMgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 08:36:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,527,1344236400"; 
   d="scan'208";a="201034883"
Date: Wed, 3 Oct 2012 13:37:40 +0100
From: Alan Cox <alan@linux.intel.com>
To: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
Cc: <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <Vineet.Gupta1@synopsys.com>
Subject: Re: [PATCH v3] serial/8250/8250_early: Prevent rounding error in
 uartclk
Message-ID: <20121003133740.69c9dbce@bob.linux.org.uk>
In-Reply-To: <1349267263-21683-1-git-send-email-abrodkin@synopsys.com>
References: <1349267263-21683-1-git-send-email-abrodkin@synopsys.com>
Organization: Intel
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.11; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So the bug had been latent and it only showed up with such low cock
> rates.

clock ?

Perhaps Greg can tweak the description as it goes in - otherwise all
fine with me
