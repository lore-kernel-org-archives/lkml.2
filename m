Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007Ab0JPQPT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 12:15:19 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:43624 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab0JPQPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 12:15:17 -0400
Date: Sat, 16 Oct 2010 17:15:16 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: Don Zickus <dzickus@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        mingo@elte.hu, fweisbec@gmail.com, robert.richter@amd.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] arch generic way to trigger unknown NMIs
In-Reply-To: <20101016153229.GA6763@lenovo>
Message-ID: <alpine.LFD.2.00.1010161710290.15889@eddie.linux-mips.org>
References: <20101007030807.GA4076@redhat.com> <20101007072641.GE5010@basil.fritz.box> <20101007140112.GN10663@redhat.com> <alpine.LFD.2.00.1010072342170.15889@eddie.linux-mips.org> <20101010202357.GA28938@lenovo> <alpine.LFD.2.00.1010160822250.15889@eddie.linux-mips.org>
 <20101016153229.GA6763@lenovo>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Oct 2010, Cyrill Gorcunov wrote:

>  Hi Maciej, the send_IPI_self could be modified to send NMI (at moment it
> uses self shortcut with fixed delivery mode). The question is rather if
> we need it without a real caller yet. When Don's patch gets merged we
> will have a real caller then and could update send_IPI_self to support
> NMI delivery mode. Something like that :)

 Sounds backwards to me.  My understanding is a need has just arisen, so 
why not:

1. Update send_IPI_self().

2. Add code that makes use of the new functionality.

3. Submit all the changes as self-contained patches in a single series to 
   be applied at the same time.

?  That's what I'd imagine the most natural way of doing this would be.

  Maciej
