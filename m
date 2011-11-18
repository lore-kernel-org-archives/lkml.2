Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778Ab1KRMCH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 07:02:07 -0500
Received: from ud10.udmedia.de ([194.117.254.50]:44724 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab1KRMCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 07:02:04 -0500
Date: Fri, 18 Nov 2011 13:02:01 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: "Alex,Shi" <alex.shi@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: WARNING: at mm/slub.c:3357, kernel BUG at mm/slub.c:3413
Message-ID: <20111118120201.GA1642@x4.trippels.de>
References: <20111118072519.GA1615@x4.trippels.de>
 <20111118075521.GB1615@x4.trippels.de>
 <1321605837.30341.551.camel@debian>
 <20111118085436.GC1615@x4.trippels.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111118085436.GC1615@x4.trippels.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011.11.18 at 09:54 +0100, Markus Trippelsdorf wrote:
> On 2011.11.18 at 16:43 +0800, Alex,Shi wrote:
> > > > 
> > > > The dirty flag comes from a bunch of unrelated xfs patches from Christoph, that
> > > > I'm testing right now.
> > 
> > Where is the xfs patchset? I am wondering if it is due to slub code. 

I begin to wonder if this might be the result of a compiler bug. 
The kernel in question was compiled with gcc version 4.7.0 20111117. And
there was commit to the gcc repository today that looks suspicious:
http://gcc.gnu.org/viewcvs?view=revision&revision=181466

Will have to dig deeper, but if this turns out to be the cause of the
issue, I apologize for the noise.

-- 
Markus
