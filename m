Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751195Ab2ECEX7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 00:23:59 -0400
Received: from tundra.namei.org ([65.99.196.166]:37543 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826Ab2ECEX4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 00:23:56 -0400
Date: Thu, 3 May 2012 14:23:48 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: Al Viro <viro@ZenIV.linux.org.uk>,
        "Jonathan Corbet <corbet@lwn.net>, Kasatkin, Dmitry" 
	<dmitry.kasatkin@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Safford <safford@linux.vnet.ibm.com>,
        David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] situation with fput() locking (was Re: [PULL REQUEST] :
 ima-appraisal patches)
In-Reply-To: <1335796351.1827.6.camel@falcor>
Message-ID: <alpine.LRH.2.02.1205031421490.7642@tundra.namei.org>
References: <1334865448.2429.35.camel@falcor>  <20120420004303.GB6871@ZenIV.linux.org.uk>  <alpine.LSU.2.00.1204201133340.1450@eggly.anvils>  <20120420190418.GK6871@ZenIV.linux.org.uk>  <CA+55aFwVJ7SFbb3ZVxnon-Vv19pbNvUN4oungH479q7DUjBtwQ@mail.gmail.com> 
 <20120420195833.GM6871@ZenIV.linux.org.uk>  <CA+55aFzaC8YfN_q1TxPbNgpD7AnoAVac2Bqa+ysEji3u7ZQ18A@mail.gmail.com>  <20120420221315.GN6871@ZenIV.linux.org.uk>  <CA+55aFzEwsW1kdLo2hpgW2PUCRkyaRxS_KB40iwmuk1FDgV+cg@mail.gmail.com> 
 <CALLzPKarZY11htkukZPi+7ny5r=au9hMdKBOy20wAdFjSBOyjA@mail.gmail.com>  <20120427173417.GK6871@ZenIV.linux.org.uk> <1335796351.1827.6.camel@falcor>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Apr 2012, Mimi Zohar wrote:

> Jon, thank you for summarizing the discussion - article
> http://lwn.net/Articles/494158/.  As Jake Edge's previous LWN article
> http://lwn.net/Articles/488906/ said, we've been working on upstreaming
> the different integrity components for quite a while.  Although
> IMA-appraisal isn't the last component, it is a major one and were
> hoping that it would be upstreamed in the near future.  Is 3.5 still a
> possibility?

Not sure why you're asking Jon, but the technical issues raised by Al need 
to be resolved before the code can be considered for upstreaming.


- James
-- 
James Morris
<jmorris@namei.org>
