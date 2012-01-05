Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479Ab2AEAXZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 19:23:25 -0500
Received: from mga02.intel.com ([134.134.136.20]:23633 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757414Ab2AEAXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 19:23:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="93044611"
Date: Thu, 5 Jan 2012 00:36:18 +0000
From: Alan Cox <alan@linux.intel.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: gregkh@suse.de, linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial: driver for m32 arch should not have DEC alpha
 errata
Message-ID: <20120105003618.2232c5d9@bob.linux.org.uk>
In-Reply-To: <1325708184-9861-1-git-send-email-paul.gortmaker@windriver.com>
References: <1325708184-9861-1-git-send-email-paul.gortmaker@windriver.com>
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

On Wed,  4 Jan 2012 15:16:24 -0500
Paul Gortmaker <paul.gortmaker@windriver.com> wrote:

> This driver was copied from the original 8250 driver and hence
> got the DEC alpha errata workaround.  But the workaround is ugly
> and we don't really want it in any more places than it absolutely
> needs to be.  Obviously ARCH=m32r means ARCH != alpha, so just
> remove the references to the ALPHA_KLUDGE_MCR define.
> 
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

Acked-by: Alan Cox <alan@linux.intel.com>
