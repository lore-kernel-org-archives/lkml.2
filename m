Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466Ab1JZG1M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 02:27:12 -0400
Received: from smtp-out.google.com ([74.125.121.67]:21789 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754023Ab1JZG1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 02:27:10 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=eEDcO36aAkNgFM00+mxlS7jfJ8OkPSt6ygkdgQFUYlwvBJ+whHnIx/LVt1V9i97ep
	TDEcMbXLqRXPfem7FEMiw==
Date: Tue, 25 Oct 2011 23:27:05 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Gene Smith <gds@chartertn.net>
cc: wwguy <wey-yi.w.guy@intel.com>, ilw@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: wifi iwlagn fails to authenticate after wake from suspend
In-Reply-To: <j881g5$tdf$1@dough.gmane.org>
Message-ID: <alpine.DEB.2.00.1110252325090.20273@chino.kir.corp.google.com>
References: <j881g5$tdf$1@dough.gmane.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Oct 2011, Gene Smith wrote:

> Now after upgrade to Ubuntu 11.10 when resume from suspend, wifi fails to
> reconnect saying waiting for authentication. When I use older kernel, 2.4.38
> instead of the new 3.0.0, it still works OK. If using ethernet, after wake
> from suspend it always works OK.
> 

So we need to bisect between 2.4.38 and 3.0.0? :)  I'm running ubuntu 
11.10 on a home laptop so I'll give this a try as well when I can if I can 
put up with unity for that long.

> More details on this bug are here
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/880648
> and here
> https://bugzilla.redhat.com/show_bug.cgi?id=7374
> 
> Tried new Ubuntu kernel 3.1-rc10 did not help. Did not try an alternate kernel
> with Fedora 15.
> 
> The common failure messages seen with Ubuntu and Fedora is this:
> 
> <info> (wlan0): device state change: need-auth -> failed (reason 'no-secrets')
> [60 120 7]
> Oct 24 01:20:00 hplt NetworkManager[1016]: <warn> Activation (wlan0) failed
> for access point (dbnet)
> 
> After this occurs, no further attempt to authenticate wifi occur and a red X
> appears over the wifi icon. I must then use ethernet (or reboot).
> 

Adding wireless folks to the cc.
