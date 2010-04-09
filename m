Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757597Ab0DIKFt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 06:05:49 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:35663 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754733Ab0DIKFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 06:05:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=f+ukt2LGv6yQeTxrgGgnKJRlvKPeZyFOyeZXp41T+w7s5SxOT6sW+sVfEfDAnQ1umJ
         LU35EGCR0t1InvZFD1+Lv9AbfKy5I7DSU+BAMyPttJGAoaXuLKNw08RF8wh/7ihHng7P
         WaJtE4mgVSjdaFrmWrnwglHI8IuSr+Y1ZaIvs=
Date: Fri, 9 Apr 2010 12:08:05 +0200
From: Richard Zidlicky <rz@linux-m68k.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: dm-crypt@saout.de, pm-utils@lists.freedesktop.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.33.2 circular locking, hibernate, dm-crypt
Message-ID: <20100409100805.GA3468@linux-m68k.org>
References: <20100408110607.GB1788@linux-m68k.org> <201004082235.25263.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201004082235.25263.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 08, 2010 at 10:35:25PM +0200, Rafael J. Wysocki wrote:

> Can you please check if this also is present in the latest 2.6.34-rc kernels
> (preferably 2.6.34-rc4 when it's out)?

I can try it, or if you have a particular patch set try to apply it to 2.6.33. It is not
100% reproducible however.

Richard
