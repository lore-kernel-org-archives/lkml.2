Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489Ab1A0UyG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 15:54:06 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58717 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137Ab1A0UyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 15:54:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ulAFKaJsXeN7AkQ9C2M8Jg1YejpD/MM9Z2wVF8ktjmiRQFnAcJzRfXTBAoOYJkcePy
         7mWRvMY1Fx8jy/05+XOnfWVEMZkV+MN6EC5s6df68VRhun6Yr0owX9XJZ8/UPXw+pFMP
         1CXHxf46PDBj5ImvXq4nhtLYa0RLEBWiuzrwc=
Date: Thu, 27 Jan 2011 22:53:57 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Ryan Mallon <ryan@bluewatersys.com>
Cc: Mandeep Singh Baines <msb@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>, olofj@chromium.org
Subject: Re: [PATCH] printk: allow setting DEFAULT_MESSAGE_LEVEL via Kconfig
Message-ID: <20110127205357.GA4731@p183.telecom.by>
References: <20110125235700.GR8008@google.com>
 <20110126144910.ce0646ec.akpm@linux-foundation.org>
 <20110126145703.a0f5add5.rdunlap@xenotime.net>
 <20110126151017.ed9e627c.akpm@linux-foundation.org>
 <20110127082718.GA4748@p183.telecom.by>
 <20110127155754.GB8520@google.com>
 <4D41D963.6020509@bluewatersys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D41D963.6020509@bluewatersys.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 28, 2011 at 09:45:23AM +1300, Ryan Mallon wrote:
> Why not make printk prefix messages that have no log level with
> "[NO_LOG_LEVEL]" or similar? That way the can easily be grepped out, and
> it provides and incentive for people to fix them :-).

Because printk("foo"); ... printk("\n"); is legit.
