Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355Ab0KRWE1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 17:04:27 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:12864 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754397Ab0KRWE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 17:04:26 -0500
Date: Thu, 18 Nov 2010 22:51:43 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Michael Ellerman <michael@ellerman.id.au>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] iSeries: Remove unused mf_getSrcHistory function and
 caller.
In-Reply-To: <1290117470.29105.9.camel@concordia>
Message-ID: <alpine.LNX.2.00.1011182249300.11697@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1010301911220.1572@swampdragon.chaosbits.net>  <1288609842.10671.7.camel@concordia>  <20101102071025.2fe5e6ca.sfr@canb.auug.org.au>  <alpine.LNX.2.00.1011012104050.12889@swampdragon.chaosbits.net>  <20101102082634.65342ce6.sfr@canb.auug.org.au>
  <alpine.LNX.2.00.1011012218420.12889@swampdragon.chaosbits.net>  <1288657250.16790.4.camel@concordia>  <alpine.LNX.2.00.1011050026220.16015@swampdragon.chaosbits.net>  <alpine.LNX.2.00.1011182044490.3651@swampdragon.chaosbits.net>
 <1290117470.29105.9.camel@concordia>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Nov 2010, Michael Ellerman wrote:

> On Thu, 2010-11-18 at 20:45 +0100, Jesper Juhl wrote:
> > On Fri, 5 Nov 2010, Jesper Juhl wrote:
> > >  
> > >  static int mf_src_proc_open(struct inode *inode, struct file *file)
> 
> > PING.
> > 
> > Is this going to get merged somewhere or is there a problem?
> 
> Yes, no.
> 
> It won't get lost:
> http://patchwork.ozlabs.org/patch/70201/
> 
Ok. Thank you for that bit of information. That was one place that I had 
no knowledge about what-so-ever, so I didn't look.

I will now rest happily in the knowledge that the patch is in good hands. 
Thanks.


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

