Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257Ab1F0Siq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 14:38:46 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48037 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304Ab1F0Sik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 14:38:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=baUB5WOtIeDrXPNQk714ZFkMBObZqHOBckSkcfIpPTynEjUMth8Q2Sg+yiELz2gYL4
         NdCrc/dYVPX+aWnqlkXvmlEPbR+Gc+tK3dD63yMfeGin0SoU6f7cHMGNKEhYl4uzH259
         p7mC0qgbC3RNf/bVzhkqgCRm8mmD1gvq7ETKw=
Date: Mon, 27 Jun 2011 22:38:29 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        James Morris <jmorris@namei.org>, Namhyung Kim <namhyung@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2] kernel: escape non-ASCII and control characters in
 printk()
Message-ID: <20110627183829.GA16033@albatros>
References: <20110623152137.GA2536@albatros>
 <20110626103915.GB11093@elte.hu>
 <20110626165409.GA2584@albatros>
 <20110626182628.GA20158@elte.hu>
 <20110626190622.GB4217@albatros>
 <20110626194618.GA21740@elte.hu>
 <20110626202518.GA4915@albatros>
 <20110626220126.GA24004@elte.hu>
 <20110627083633.GA5846@albatros>
 <20110627104058.45e93c41@pyx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110627104058.45e93c41@pyx>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 27, 2011 at 10:40 +0100, Alan Cox wrote:
> 
> Go back and read what I said originally, and think about it.
> 
> You have to look at the IUTF bit of the relevant console you are logging
> to.

The knowledge of what specific console is relevant is unknown at the
moment of printk().  Do you approve only filtering on klogd side?

> But arbitarily blocking anything non ASCII is going to make a mess in
> anything non American. Even English needs UTF-8.

Sure, I don't propose it anymore (v2 goes without it).


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
