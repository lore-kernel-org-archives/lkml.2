Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964784Ab2EKQlb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 12:41:31 -0400
Received: from mga03.intel.com ([143.182.124.21]:11304 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932215Ab2EKQlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 12:41:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="141942889"
Date: Fri, 11 May 2012 17:56:48 +0100
From: Alan Cox <alan@linux.intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] ata_generic: Skip is_intel_ider() check when
 ata_generic=1 is set
Message-ID: <20120511175648.19f2eaa5@bob.linux.org.uk>
In-Reply-To: <1336754003-31487-1-git-send-email-andi@firstfloor.org>
References: <1336754003-31487-1-git-send-email-andi@firstfloor.org>
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

On Fri, 11 May 2012 09:33:23 -0700
Andi Kleen <andi@firstfloor.org> wrote:

> From: Andi Kleen <ak@linux.intel.com>
> 
> When ata_generic_ide=1 is set don't do the is_intel_ider() magic
> check. We found at least one box who needed that.
> 
> Cc: alan@linux.intel.com
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

Acked-by: Alan Cox <alan@linux.intel.com>
