Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405Ab0JQQIX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 12:08:23 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:42014 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757020Ab0JQQIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 12:08:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=N1dxlUxaBdbmrQzeieUbb3MP2W+McD/SVIdNX/WzcaI15GXxq9D41OSBNs2a7ZM933
         qX1ZKnJ4ncb/fFuPijeJPNaVECIaxRaw8jBEeSPuONIYqpC/k7hDDATV1zE3zqLqj39s
         ElunZnte1fjSbMm6HQL57yc/FREDCyBVeMsdU=
Date: Sun, 17 Oct 2010 20:08:16 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Don Zickus <dzickus@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        mingo@elte.hu, fweisbec@gmail.com, robert.richter@amd.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] arch generic way to trigger unknown NMIs
Message-ID: <20101017160816.GC7925@lenovo>
References: <20101007072641.GE5010@basil.fritz.box> <20101007140112.GN10663@redhat.com> <alpine.LFD.2.00.1010072342170.15889@eddie.linux-mips.org> <20101010202357.GA28938@lenovo> <alpine.LFD.2.00.1010160822250.15889@eddie.linux-mips.org> <20101016153229.GA6763@lenovo> <alpine.LFD.2.00.1010161710290.15889@eddie.linux-mips.org> <20101016163657.GB6763@lenovo> <alpine.LFD.2.00.1010170055260.15889@eddie.linux-mips.org> <20101017085828.GA7925@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101017085828.GA7925@lenovo>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 17, 2010 at 12:58:28PM +0400, Cyrill Gorcunov wrote:
...
> >  How different is it to the other two send_IPI shorthand calls?  Or the 
> > fully-fledged one?  I gather from this thread they already handle NMIs 
> > properly, so what is there within that cannot simply be copied over to 
> > this one?
> > 
> >   Maciej
> > 
> 
>  Hmm, good question ;) I thought about 82489dx which required level
> trigger mode for nmi delivery, new (or present day) apics always
> use edge trigger mode so indeed there is no need for level assert/deassert.
> 
>   Cyrill

I'll try to cook a patch for this.

  Cyrill
