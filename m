Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109Ab0KKTIM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 14:08:12 -0500
Received: from one.firstfloor.org ([213.235.205.2]:49917 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755973Ab0KKTII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 14:08:08 -0500
Date: Thu, 11 Nov 2010 20:08:02 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Nick Bowler <nbowler@elliptictech.com>, Andi Kleen <andi@firstfloor.org>,
        bjschuma@netapp.com, torvalds@linux-foundation.org,
        linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [regression] NFS readdir change break fully cached nfs root
Message-ID: <20101111190802.GH18718@basil.fritz.box>
References: <20101102180051.GA26089@basil.fritz.box>
 <1288731930.534.1.camel@heimdal.trondhjem.org>
 <20101103162423.GA3797@elliptictech.com>
 <1288886814.3285.5.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288886814.3285.5.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Trond, I noticed that this is still broken in Linus' current tree,
somewhat disrupting testing here. Could you please submit the fixes
for this ASAP?

Thanks,
-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
