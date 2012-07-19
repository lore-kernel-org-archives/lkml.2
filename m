Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404Ab2GSKYM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 06:24:12 -0400
Received: from mga01.intel.com ([192.55.52.88]:57454 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752594Ab2GSKYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 06:24:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="194947289"
Date: Thu, 19 Jul 2012 11:41:12 +0100
From: Alan Cox <alan@linux.intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the tty tree
Message-ID: <20120719114112.1ccccb54@bob.linux.org.uk>
In-Reply-To: <20120719143627.adc9d5e5333449d6c8588a99@canb.auug.org.au>
References: <20120719143627.adc9d5e5333449d6c8588a99@canb.auug.org.au>
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

> Caused by commit adc8d746caa6 ("tty: move the termios object into the
> tty").  Grep and build testing are your friends ...
> 
> I have used the tty tree from next-20120712 again for today.

Doh, patch sent

