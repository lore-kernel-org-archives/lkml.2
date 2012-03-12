Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586Ab2CLNdW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 09:33:22 -0400
Received: from mga11.intel.com ([192.55.52.93]:25071 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755426Ab2CLNdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 09:33:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="137388484"
Message-ID: <1331559361.12037.29.camel@sauron.fi.intel.com>
Subject: Re: [patch] Adding Secure Deletion to UBIFS
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Joel Reardon <joel@clambassador.com>
Cc: linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 12 Mar 2012 15:36:01 +0200
In-Reply-To: <1331559053.12037.25.camel@sauron.fi.intel.com>
References: <alpine.DEB.2.00.1202091615540.26924@eristoteles.iwoars.net>
	 <1330536308.3545.158.camel@sauron.fi.intel.com>
	 <alpine.DEB.2.00.1203011434220.2462@eristoteles.iwoars.net>
	 <1331278562.22872.18.camel@sauron.fi.intel.com>
	 <alpine.DEB.2.00.1203091959570.25737@eristoteles.iwoars.net>
	 <1331559053.12037.25.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-12 at 15:30 +0200, Artem Bityutskiy wrote:
> >  Btw, when I was
> > developing it I used the last 8 bytes from the key as the key position,
> > because the key was 16 bytes but only 8 were used. Could you comment on
> > the last 8 bytes of ubifs keys?
> 
> I think you can use them. But is it possible to kill these things from
> the data nodes themselves? We can always find it by looking up the index
> by the data node key, right?

Joel, but please, send small patches, preparation patches, etc. Do not
disappear for several months and do not come back with another big
patch. Tell about your intentions in advance.

E.g., if you decide to start using those unused 8 bytes - first do small
preparations like removing the notion of "key scheme" which we
provisioned but never used (from comments as well). Clean-up the "space"
for yourself. Then start using them for your purposes. As I said, as
soon as I get the first patch I like, I'll create a separate branch in
the UBIFS git tree for your work.

Thanks!

-- 
Best Regards,
Artem Bityutskiy

