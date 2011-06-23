Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934558Ab1FWXRz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 19:17:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:37661 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933456Ab1FWXRy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 19:17:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,416,1304319600"; 
   d="scan'208";a="22181469"
Date: Fri, 24 Jun 2011 00:17:06 +0100
From: Alan Cox <alan@linux.intel.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: LKML <linux-kernel@vger.kernel.org>, trivial@kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org
Subject: Re: [PATCH 20/37] Remove unneeded version.h includes from
 drivers/staging/gma500/
Message-ID: <20110624001706.2a2719e3@bob.linux.org.uk>
In-Reply-To: <alpine.LNX.2.00.1106240040050.17688@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
	<alpine.LNX.2.00.1106240040050.17688@swampdragon.chaosbits.net>
Organization: Intel
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Jun 2011 00:41:01 +0200 (CEST)
Jesper Juhl <jj@chaosbits.net> wrote:

> It was pointed out by 'make versioncheck' that some includes of
> linux/version.h are not needed in drivers/staging/gma500/.
> This patch removes them.

Thanks will rebase onto the end of the current patch set and tweak it
to apply.
