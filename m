Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757938Ab2IJMwf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 08:52:35 -0400
Received: from mga03.intel.com ([143.182.124.21]:65153 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757849Ab2IJMwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 08:52:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,398,1344236400"; 
   d="scan'208";a="190871184"
Date: Mon, 10 Sep 2012 14:10:21 +0100
From: Alan Cox <alan@linux.intel.com>
To: leroy christophe <christophe.leroy@c-s.fr>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Vitaly Bordug <vitb@kernel.crashing.org>,
        Marcelo Tosatti <marcelo@kvack.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] Powerpc 8xx CPM_UART delay in receive
Message-ID: <20120910141021.6e7762d6@bob.linux.org.uk>
In-Reply-To: <504D922C.1030407@c-s.fr>
References: <201208141426.q7EEQSPc003956@localhost.localdomain>
	<20120814155227.018988da@pyramind.ukuu.org.uk>
	<502CF2A0.8080109@c-s.fr>
	<20120816152918.5ed2649f@pyramind.ukuu.org.uk>
	<502D054B.3010606@c-s.fr>
	<20120816162136.059b64b4@bob.linux.org.uk>
	<504D922C.1030407@c-s.fr>
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

> * a value of 1 for all rates below 2400 (On 8250, fifo is set to 1
> for such rates)
> * a value of 2 for 2400 and 4800
> * a value of 4 for 9600 (which is the default on the 8250 for all
> rates above 2400)
> * a value of 8 for 19200
> * a value of 16 for 38400 and above (on UCC_UART, maxidl is set to
> 16, never 32)

That would seem sensible.



Alan
