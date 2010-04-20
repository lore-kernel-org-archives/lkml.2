Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953Ab0DTJA2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 05:00:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:55055 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775Ab0DTJA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 05:00:26 -0400
Date: Tue, 20 Apr 2010 11:00:25 +0200
From: Heinz Diehl <htd@fancy-poultry.org>
To: linux-kernel@vger.kernel.org
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [Bug #15711] 2.6.34-rc3, BUG at mm/slab.c:2989
Message-ID: <20100420090025.GA7997@fancy-poultry.org>
References: <deuQKFRcc0B.A.3EG.BRSzLB@tosh>
 <YeFfFNFyTSF.A.zvH.wRSzLB@tosh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YeFfFNFyTSF.A.zvH.wRSzLB@tosh>
X-Accept-Language: no,dk,se,en,de
Organization: private site
X-OpenPGP-KeyID: 0xA9353F12
X-OpenPGP-Fingerprint: C67E 9A93 1033 DF8A 9321  9F90 DC39 B8C3 A935 3F12
X-OpenPGP-URL: http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.20+20100402 (GNU/Linux)
X-Provags-ID: V01U2FsdGVkX1+FLJHooZpunTuLOIgpLHBgr2P7EZ1ZFOA8CBI
 i+Bnpq4YN2zR+qeaerpEZ9meobBLFRWaRrkYRyH0bmhNEKEHEv
 AvrjKYqb7KRB4eEIGuHAg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.04.2010, Rafael J. Wysocki wrote: 

> The following bug entry is on the current list of known regressions
> from 2.6.33.  Please verify if it still should be listed and let the tracking team
> know (either way).
 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15711
> Subject		: 2.6.34-rc3, BUG at mm/slab.c:2989
> Submitter	: Heinz Diehl <htd@fancy-poultry.org>
> Date		: 2010-04-01 17:52 (19 days old)
> Message-ID	: <20100401175225.GA6581@fancy-poultry.org>
> References	: http://marc.info/?l=linux-kernel&m=127014437406250&w=2

Don't know if this is still present, after reporting it here on the list,
I've been advised by Chr. Lameter to switch from slab to slub. I did, and
haven't seen this again.

