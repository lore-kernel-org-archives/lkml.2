Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677Ab2LCLpV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 06:45:21 -0500
Received: from mga02.intel.com ([134.134.136.20]:1392 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235Ab2LCLpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 06:45:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,206,1355126400"; 
   d="scan'208";a="251008359"
Date: Mon, 3 Dec 2012 11:47:47 +0000
From: Alan Cox <alan@linux.intel.com>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jamie Iles <jamie@jamieiles.com>, linux-serial@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 3/5] serial: 8250_dw: Map IO memory
Message-ID: <20121203114747.17db30bc@bob.linux.org.uk>
In-Reply-To: <1354533479-27306-4-git-send-email-heikki.krogerus@linux.intel.com>
References: <1354533479-27306-1-git-send-email-heikki.krogerus@linux.intel.com>
	<1354533479-27306-4-git-send-email-heikki.krogerus@linux.intel.com>
Organization: Intel
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.13; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  3 Dec 2012 13:17:57 +0200
Heikki Krogerus <heikki.krogerus@linux.intel.com> wrote:

> This needs to be done in order to later access the
> Designware specific registers.
> 
> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>

Series Acked-by: Alan Cox <alan@linux.intel.com>
