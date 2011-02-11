Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758273Ab1BKWKY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 17:10:24 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:64715 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756829Ab1BKWKX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 17:10:23 -0500
MIME-Version: 1.0
Message-ID: <b4feb995-1e73-4c12-8c58-ad0c2252233c@default>
Date: Fri, 11 Feb 2011 14:09:03 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Valdis.Kletnieks@vt.edu, akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        Nitin Gupta <ngupta@vflare.org>
Subject: RE: mmotm 2011-02-10-16-26 uploaded
References: <201102110100.p1B10sDx029244@imap1.linux-foundation.org
 53491.1297461155@localhost>
In-Reply-To: <53491.1297461155@localhost>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6550.5003]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4D55B3C7.0015:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Valdis.Kletnieks@vt.edu [mailto:Valdis.Kletnieks@vt.edu]
> Sent: Friday, February 11, 2011 2:53 PM
> To: akpm@linux-foundation.org; Dan Magenheimer
> Cc: mm-commits@vger.kernel.org; linux-kernel@vger.kernel.org; linux-
> mm@kvack.org; linux-fsdevel@vger.kernel.org
> Subject: Re: mmotm 2011-02-10-16-26 uploaded
> 
> On Thu, 10 Feb 2011 16:26:36 PST, akpm@linux-foundation.org said:
> > The mm-of-the-moment snapshot 2011-02-10-16-26 has been uploaded to
> >
> >    http://userweb.kernel.org/~akpm/mmotm/
> 
> CONFIG_ZCACHE=m dies a horrid death:

Thanks Valdis.  A fix for this has already been posted by
Nitin Gupta and Randy Dunlap here:

https://lkml.org/lkml/2011/2/10/383 

Another patch for a zcache memory leak has been posted here:

https://lkml.org/lkml/2011/2/10/306 

I'm sorry that multiple people have run into this in
multiple trees.
I have to admit I am a bit baffled as to what the proper
tree flow is for bug fixes like this, but would be happy
to "follow the process" if I am told what it is or if
someone can point me to a document describing it.

(Clearly making sure there are no bugs at all in a
submission is the best way to go, but I'm afraid
I can't claim to be perfect :-)

Thanks,
Dan

P.S. I suppose there isn't really a good reason for
CONFIG_ZCACHE to be tri-state as it really makes
no sense as a module because, if CONFIG_CLEANCACHE
is enabled, it will always get loaded.
