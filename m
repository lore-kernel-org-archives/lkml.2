Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab1DAIGE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 04:06:04 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43564 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123Ab1DAIFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 04:05:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=JrFxm+OOEFaixe107tz48GdWlcn7yEKzs6KvN+oua6ymx7Ce53V5MgZQhy3Ay7Dk6C
         qOlBPODDC8CN6vwJ63Xr32jNwr/FLkqQksGd9ovJUZbTnk3V1HGQqbknthieu2q8rAar
         gayF1ohuOX+X0uxHsGysVsJrbKu+2AfRK/xZw=
MIME-Version: 1.0
In-Reply-To: <20110323145418.GE13315@redhat.com>
References: <AANLkTikEYDdL08=DdJ7fLR08r6sWDCHbNoOuGhxGhm7G@mail.gmail.com>
	<20110323142505.GD13315@redhat.com>
	<AANLkTi=EoPKcBE1miW_-RHgHTBCSDKJ1My=Z40rrhm1x@mail.gmail.com>
	<20110323145418.GE13315@redhat.com>
Date: Fri, 1 Apr 2011 10:05:41 +0200
Message-ID: <AANLkTi=rMdCz97QLkz=xHy7AxfxFVEgsf=qmXKc5ORWE@mail.gmail.com>
Subject: Re: Support for global block IO throttling?
From: Juerg Haefliger <juergh@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,


> Also current IO controller does not work for NFS. So if a global limit
> is imposed in higher layers it will solve that issue too.
>
> Also if you implement it above page cache then it should automatically
> handle the case of async writes too. The downside is that if limits
> are low, buffered writers will be throttled very frequently.

I'm not exactly sure where in the stack you see this global bandwidth
controller. What do you mean by 'above the page cache'? I interpret
this such that access to the page cache would be bandwidth limited as
well? That doesn't sound right to me.

Thanks
...Juerg
