Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932212Ab1LEMGj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 07:06:39 -0500
Received: from mga11.intel.com ([192.55.52.93]:19461 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932122Ab1LEMGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 07:06:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,298,1320652800"; 
   d="scan'208";a="92393044"
Date: Mon, 5 Dec 2011 12:18:33 +0000
From: Alan Cox <alan@linux.intel.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: gregkh@suse.de, scottwood@freescale.com, galak@kernel.crashing.org,
        linux-serial@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] RFCv2 Fix Fsl 8250 BRK bug
Message-ID: <20111205121833.64de10e2@bob.linux.org.uk>
In-Reply-To: <1323042143-25330-1-git-send-email-paul.gortmaker@windriver.com>
References: <1322783258-20443-1-git-send-email-paul.gortmaker@windriver.com>
	<1323042143-25330-1-git-send-email-paul.gortmaker@windriver.com>
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

> Anyway, have a look and see if this version of things is acceptable
> to all.  (Again, the dts update from Kumar isn't shown here).
> 
> Thanks to all who provided the feedback on v1.

Looks good to me

Acked-by: Alan Cox <alan@linux.intel.com>
