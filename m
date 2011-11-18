Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab1KRIyk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 03:54:40 -0500
Received: from ud10.udmedia.de ([194.117.254.50]:44146 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447Ab1KRIyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 03:54:39 -0500
Date: Fri, 18 Nov 2011 09:54:36 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: "Alex,Shi" <alex.shi@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: WARNING: at mm/slub.c:3357, kernel BUG at mm/slub.c:3413
Message-ID: <20111118085436.GC1615@x4.trippels.de>
References: <20111118072519.GA1615@x4.trippels.de>
 <20111118075521.GB1615@x4.trippels.de>
 <1321605837.30341.551.camel@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321605837.30341.551.camel@debian>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011.11.18 at 16:43 +0800, Alex,Shi wrote:
> > > 
> > > The dirty flag comes from a bunch of unrelated xfs patches from Christoph, that
> > > I'm testing right now.
> 
> Where is the xfs patchset? I am wondering if it is due to slub code. It
> is also possible xfs set a incorrect page flags. 

http://thread.gmane.org/gmane.comp.file-systems.xfs.general/41810

-- 
Markus
