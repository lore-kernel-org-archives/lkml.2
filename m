Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720Ab1KASg3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 14:36:29 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:45749 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798Ab1KASg2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 14:36:28 -0400
MIME-Version: 1.0
Message-ID: <e51b28f7-da4a-4c53-889d-4f12b8dd701a@default>
Date: Tue, 1 Nov 2011 11:35:28 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>, Nitin Gupta <ngupta@vflare.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>, Greg KH <greg@kroah.com>,
        gregkh@suse.de, devel@driverdev.osuosl.org, cascardo@holoscopio.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        brking@linux.vnet.ibm.com, rcj@linux.vnet.ibm.com
Subject: RE: [PATCH v2 0/3] staging: zcache: xcfmalloc support
References: <1315404547-20075-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <20110909203447.GB19127@kroah.com> <4E6ACE5B.9040401@vflare.org>
 <4E6E18C6.8080900@linux.vnet.ibm.com> <4E6EB802.4070109@vflare.org>
 <4E6F7DA7.9000706@linux.vnet.ibm.com> <4E6FC8A1.8070902@vflare.org>
 <4E72284B.2040907@linux.vnet.ibm.com> <4E738B81.2070005@vflare.org
 1320168615.15403.80.camel@nimitz>
In-Reply-To: <1320168615.15403.80.camel@nimitz>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6562.5003]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090204.4EB03BF5.00E6,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Dave Hansen [mailto:dave@linux.vnet.ibm.com]
> Sent: Tuesday, November 01, 2011 11:30 AM
> To: Nitin Gupta
> Cc: Seth Jennings; Greg KH; gregkh@suse.de; devel@driverdev.osuosl.org; Dan Magenheimer;
> cascardo@holoscopio.com; linux-kernel@vger.kernel.org; linux-mm@kvack.org; brking@linux.vnet.ibm.com;
> rcj@linux.vnet.ibm.com
> Subject: Re: [PATCH v2 0/3] staging: zcache: xcfmalloc support
> 
> On Fri, 2011-09-16 at 13:46 -0400, Nitin Gupta wrote:
> > I think replacing allocator every few weeks isn't a good idea. So, I
> > guess better would be to let me work for about 2 weeks and try the slab
> > based approach.  If nothing works out in this time, then maybe xcfmalloc
> > can be integrated after further testing.
> 
> Hi Nitin,
> 
> It's been about six weeks. :)
> 
> Can we talk about putting xcfmalloc() in staging now?

FWIW, given that I am quoting "code rules!" to the gods of Linux
on another lkml thread, I can hardly disagree here.

If Nitin continues to develop his allocator and it proves
better than xcfmalloc (and especially if it can replace
zbud as well), we can consider replacing xcfmalloc later.
Until zcache is promoted from staging, I think we have
that flexibility.

(Shameless advertisement though:  The xcfmalloc allocator
only applies to pages passed via frontswap, and on
that other lkml thread lurk many people intent on shooting
frontswap down.  So, frankly, I'd prefer time to be spent
on benchmarking zcache rather than on arguing about
allocators which, as things currently feel to me on that
other lkml thread, is not unlike rearranging deck chairs
on the Titanic. Half-:-).

Dan
