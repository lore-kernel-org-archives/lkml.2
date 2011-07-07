Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518Ab1GGKmU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 06:42:20 -0400
Received: from mga03.intel.com ([143.182.124.21]:19621 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752253Ab1GGKmU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 06:42:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,492,1304319600"; 
   d="scan'208";a="23771331"
Date: Thu, 7 Jul 2011 11:42:47 +0100
From: Alan Cox <alan@linux.intel.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: LKML <linux-kernel@vger.kernel.org>, trivial@kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org
Subject: Re: [PATCH 20/37] Remove unneeded version.h includes from
 drivers/staging/gma500/
Message-ID: <20110707114247.2b31a132@bob.linux.org.uk>
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

>  Remove unneeded version.h includes from drivers/staging/gma500/

Applied and updated now the file juggling has all calmed down
