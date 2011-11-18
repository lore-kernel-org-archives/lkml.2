Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746Ab1KRIoO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 03:44:14 -0500
Received: from mga14.intel.com ([143.182.124.37]:27464 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755066Ab1KRIoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 03:44:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,532,1315206000"; 
   d="scan'208";a="38594764"
Subject: Re: WARNING: at mm/slub.c:3357, kernel BUG at mm/slub.c:3413
From: "Alex,Shi" <alex.shi@intel.com>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <20111118075521.GB1615@x4.trippels.de>
References: <20111118072519.GA1615@x4.trippels.de>
	 <20111118075521.GB1615@x4.trippels.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Nov 2011 16:43:57 +0800
Message-ID: <1321605837.30341.551.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > The dirty flag comes from a bunch of unrelated xfs patches from Christoph, that
> > I'm testing right now.

Where is the xfs patchset? I am wondering if it is due to slub code. It
is also possible xfs set a incorrect page flags. 

> > 
> > Please also see my previous post: http://thread.gmane.org/gmane.linux.kernel/1215023
> > It looks like something is scribbling over memory.
> > 
> > This machine uses ECC, so bit-flips should be impossible.
> 
> CC'ing netdev@vger.kernel.org and Eric Dumazet.
> 


