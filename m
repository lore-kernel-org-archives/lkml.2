Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059Ab1LBAkW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 19:40:22 -0500
Received: from mga09.intel.com ([134.134.136.24]:5199 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755770Ab1LBAkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 19:40:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="81974769"
Date: Fri, 2 Dec 2011 00:51:50 +0000
From: Alan Cox <alan@linux.intel.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: gregkh@suse.de, galak@kernel.crashing.org, scottwood@freescale.com,
        linux-serial@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] serial: make bugs field not specific to 8250 type
 uarts.
Message-ID: <20111202005150.2e9fde43@bob.linux.org.uk>
In-Reply-To: <1322783258-20443-2-git-send-email-paul.gortmaker@windriver.com>
References: <1322783258-20443-1-git-send-email-paul.gortmaker@windriver.com>
	<1322783258-20443-2-git-send-email-paul.gortmaker@windriver.com>
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

> Make the bugs field part of the globally visible struct
> uart_port and remove the 8250 specific one.

Except all the bits in it are 8250 specific things or names that are
meaningless in generic form - no. I also don't want to encourage flags
and bug bits. We already have too many and its making the code a mess.
So right now we want less not more.
