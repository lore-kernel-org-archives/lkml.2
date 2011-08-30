Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab1H3XOP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 19:14:15 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:26647 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422Ab1H3XON convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 19:14:13 -0400
MIME-Version: 1.0
Message-ID: <4599ff4c-5273-4605-9a61-d26a9a6484fe@default>
Date: Tue, 30 Aug 2011 14:51:39 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, jeremy@goop.org,
        hughd@google.com, ngupta@vflare.org,
        Konrad Wilk <konrad.wilk@oracle.com>, JBeulich@novell.com,
        Kurt Hackel <kurt.hackel@oracle.com>, npiggin@kernel.dk,
        akpm@linux-foundation.org, riel@redhat.com, hannes@cmpxchg.org,
        matthew@wil.cx, Chris Mason <chris.mason@oracle.com>,
        sjenning@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com,
        jackdachef@gmail.com, cyclonusj@gmail.com, levinsasha928@gmail.com
Subject: RE: [PATCH V8 4/4] mm: frontswap: config and doc files
References: <20110829164949.GA27238@ca-server1.us.oracle.com
 19213.1314737185@turing-police.cc.vt.edu>
In-Reply-To: <19213.1314737185@turing-police.cc.vt.edu>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6557.5001]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090204.4E5D6E6E.00A2,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Valdis.Kletnieks@vt.edu [mailto:Valdis.Kletnieks@vt.edu]
> Subject: Re: [PATCH V8 4/4] mm: frontswap: config and doc files
> 
> On Mon, 29 Aug 2011 09:49:49 PDT, Dan Magenheimer said:
> 
> > --- linux/mm/Kconfig	2011-08-08 08:19:26.303686905 -0600
> > +++ frontswap/mm/Kconfig	2011-08-29 09:52:14.308745832 -0600
> > @@ -370,3 +370,20 @@ config CLEANCACHE
> >  	  in a negligible performance hit.
> >
> >  	  If unsure, say Y to enable cleancache
> > +
> > +config FRONTSWAP
> > +	bool "Enable frontswap to cache swap pages if tmem is present"
> > +	depends on SWAP
> > +	default n
> 
> > +
> > +	  If unsure, say Y to enable frontswap.
> 
> Am I the only guy who gets irked when the "default" doesn't match the
> "If unsure" suggestion?  :)  (and yes, I know we have guidelines for
> what the "default" should be...)

Hi Valdis --

Thanks for the review!

Count me as irked.  The default should be "y" because the
overhead is extremely tiny when not enabled at runtime by
a backend (though admittedly non-zero), but I got flamed by
Linus last time I tried that (for cleancache), so I'm not
going to try it for frontswap! :-)  The "if unsure" is the
best I can do for now to encourage distros to enable it.

Dan
