Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab2CHLFK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 06:05:10 -0500
Received: from mga01.intel.com ([192.55.52.88]:35990 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752575Ab2CHLFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 06:05:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="126529140"
Date: Thu, 8 Mar 2012 11:18:46 +0000
From: Alan Cox <alan@linux.intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/7] tty: powerpc: remove SERIAL_ICOM dependency on
 PPC_ISERIES
Message-ID: <20120308111846.27c7cfae@bob.linux.org.uk>
In-Reply-To: <20120308153931.b1b8b4f27d8e4a94b219bf4c@canb.auug.org.au>
References: <20120308152853.b5010336abbb8f90e8a2500c@canb.auug.org.au>
	<20120308153931.b1b8b4f27d8e4a94b219bf4c@canb.auug.org.au>
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

On Thu, 8 Mar 2012 15:39:31 +1100
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> The PowerPC legacy iSeries platform is being removed so this is no
> longer selectable.

Fine by me
