Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974Ab1KCOQR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 10:16:17 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:64955 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086Ab1KCOQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 10:16:16 -0400
Date: Thu, 3 Nov 2011 10:15:01 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Rusty Russell <rusty@ozlabs.org>, Stephen Boyd <sboyd@codeaurora.org>,
        Joe Perches <joe@perches.com>, Miche Baker-Harvey <miche@google.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, Amit Shah <amit.shah@redhat.com>,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        virtualization@lists.linux-foundation.org,
        Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Subject: Re: [PATCH] VirtioConsole support.
Message-ID: <20111103141501.GB26799@phenom.dumpdata.com>
References: <20111027173527.GA23839@phenom.dumpdata.com>
 <1319751802-27013-1-git-send-email-miche@google.com>
 <1319770558.2529.20.camel@Joe-Laptop>
 <4EAAF23C.8050102@codeaurora.org>
 <87k47itc7u.fsf@rustcorp.com.au>
 <4EB28B37.8030301@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EB28B37.8030301@de.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4EB2A1F2.0026,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 03, 2011 at 01:38:15PM +0100, Christian Borntraeger wrote:
> On 02/11/11 23:02, Rusty Russell wrote:
> > Ben, Christian, can you figure out what's going on?  Is it time for a
> > complete rewrite?
> 
> You are talking about hvc console? Yes it has so many users that it is now
> something like a console/tty layer extension, but it was never designed to be
> one. 
> 
> I think the hardest part would be to get all users together (for testing and
> requirements) and then to find someone that is actually doing that rework. Dont

I am volunteering myself to test the Xen user of it. Perhaps even add some patches,
albeit my knowledge of the hvc console is that "it works" (well, with this minor
speed bump).

> know if the pain level is already that high?
> 
> Christian
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
