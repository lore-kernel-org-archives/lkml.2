Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759110Ab1JFSoZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 14:44:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39704 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758999Ab1JFSoY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 14:44:24 -0400
Date: Thu, 6 Oct 2011 14:43:50 -0400
From: Jason Baron <jbaron@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "David S. Miller" <davem@davemloft.net>,
        David Daney <david.daney@cavium.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Jan Glauber <jang@linux.vnet.ibm.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        peterz@infradead.org, rth@redhat.com
Subject: Re: [PATCH RFC V2 3/5] jump_label: if a key has already been
 initialized, don't nop it out
Message-ID: <20111006184350.GD2505@redhat.com>
References: <4E89E28C.7010700@goop.org>
 <20111004141011.GA2520@redhat.com>
 <4E8B3489.60902@zytor.com>
 <4E8CF348.4080405@goop.org>
 <4E8CF385.2080804@zytor.com>
 <4E8DEB19.1050509@goop.org>
 <20111006181055.GA2505@redhat.com>
 <4E8DF02B.7010406@goop.org>
 <20111006183319.GB2505@redhat.com>
 <4E8DF505.6050807@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E8DF505.6050807@zytor.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 06, 2011 at 11:35:49AM -0700, H. Peter Anvin wrote:
> On 10/06/2011 11:33 AM, Jason Baron wrote:
> > 
> > cool. It does add some complication, I think...detecting the 2-byte vs.
> > 5-byte, and if done at boot time, possibly taking the undesired
> > branch...
> > 
> 
> It has to be done at build time to be sane, IMO.
> 
> 	-hpa
> 

agreed.

-Jason
