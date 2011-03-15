Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359Ab1COFCb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 01:02:31 -0400
Received: from smtp-out.google.com ([216.239.44.51]:27070 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522Ab1COFC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 01:02:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=GokxcBHnIQvEpsYBdzYxlim70/+yrDzO02NZG34TjQXJf3KbHI8eeQWLxYGmo6smLP
         CBprwANdSvTygIp3EHGQ==
Date: Mon, 14 Mar 2011 21:29:04 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Linux 2.6.38
In-Reply-To: <AANLkTinj2sXd0tu=Xv8E76hQRmGb9eebKeJSYW5syMjW@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1103142128330.13404@chino.kir.corp.google.com>
References: <AANLkTi=_cZRNPU29+MJkt9u6zDSLo153CKqLqg1+t7O6@mail.gmail.com> <alpine.DEB.2.00.1103142011550.16032@chino.kir.corp.google.com> <AANLkTinj2sXd0tu=Xv8E76hQRmGb9eebKeJSYW5syMjW@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Mar 2011, Linus Torvalds wrote:

> > This kernel includes a broken commit that was merged a couple of hours
> > before release:
> 
> Actually, it doesn't. It got reverted before the release because of
> the worries about it.
> 

Looks good, thanks!
