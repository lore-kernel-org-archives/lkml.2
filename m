Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117Ab0KAVas (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 17:30:48 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:23105 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754877Ab0KAVaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 17:30:46 -0400
Date: Mon, 1 Nov 2010 22:20:13 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: michael@ellerman.id.au, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iSeries: Remove unused mf_getSrcHistory function.
In-Reply-To: <20101102082634.65342ce6.sfr@canb.auug.org.au>
Message-ID: <alpine.LNX.2.00.1011012218420.12889@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1010301911220.1572@swampdragon.chaosbits.net> <1288609842.10671.7.camel@concordia> <20101102071025.2fe5e6ca.sfr@canb.auug.org.au> <alpine.LNX.2.00.1011012104050.12889@swampdragon.chaosbits.net>
 <20101102082634.65342ce6.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Tue, 2 Nov 2010, Stephen Rothwell wrote:

> On Mon, 1 Nov 2010 21:06:23 +0100 (CET) Jesper Juhl <jj@chaosbits.net> wrote:
> >
> > Remove unused function 'mf_getSrcHistory' (that will never be used ever 
> > according to Stephen Rothwell).
> > 
> > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> 
> Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>
> 

Ok, so if you are the (unofficial) iSeries maintainer and you don't merge 
the patch somewhere that'll eventually go up-stream, but just ACK it 
(thank you for that btw), then where do I send it to get it merged?

-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

