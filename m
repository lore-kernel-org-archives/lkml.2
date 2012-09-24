Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158Ab2IXNTu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 09:19:50 -0400
Received: from mga03.intel.com ([143.182.124.21]:35688 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754285Ab2IXNTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 09:19:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,476,1344236400"; 
   d="scan'208";a="148393331"
Date: Mon, 24 Sep 2012 14:21:10 +0100
From: Alan Cox <alan@linux.intel.com>
To: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Vitaly Bordug <vitb@kernel.crashing.org>,
        Marcelo Tosatti <marcelo@kvack.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] Powerpc 8xx CPM_UART setting MAXIDL register
 proportionaly to baud rate
Message-ID: <20120924142110.4a07a225@bob.linux.org.uk>
In-Reply-To: <201209240639.q8O6di6f029596@localhost.localdomain>
References: <201209240639.q8O6di6f029596@localhost.localdomain>
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

On Mon, 24 Sep 2012 08:39:44 +0200
Christophe Leroy <christophe.leroy@c-s.fr> wrote:

> MAXIDL is the timeout after which a receive buffer is closed when not
> full if no more characters are received. We calculate it from the
> baudrate so that the duration is always the same at standard rates:
> about 4ms. At 9600 bauds it gives a timeout of 4 characters, which is
> the timeout on the 8250 UART.
> 
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

Looks good tome - series Acked-by: Alan Cox <alan@linux.intel.com>
