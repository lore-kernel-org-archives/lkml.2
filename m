Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757841Ab0EBAOj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 20:14:39 -0400
Received: from mail-iw0-f182.google.com ([209.85.223.182]:38546 "EHLO
	mail-iw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754249Ab0EBAOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 20:14:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=F0YgcKPf7201cX1g8eZAV9/3i2zop6CQKsLTn/m7CTdSKBoQ2288tEFDZzMYPNs4XT
         tAUjL9AkodbICZIXNmp8uL/UsaRy21R7aomjBtU0pDXnZuhhCvqd/po1eT3y/YhB9Tz9
         lyLXp8thOXKWpQphCbiUy5eGTLYKt168XNCbc=
Date: Sat, 1 May 2010 20:14:27 -0400
From: Josh Boyer <jwboyer@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: orenl@cs.columbia.edu, akpm@linux-foundation.org,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       serue@us.ibm.com, matthltc@us.ibm.com, xemul@openvz.org,
       sukadev@linux.vnet.ibm.com, linux-api@vger.kernel.org, x86@kernel.org,
       linux-s390@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH v21 001/100] eclone (1/11): Factor out code to allocate
	pidmap page
Message-ID: <20100502001427.GH2671@hansolo.jdub.homelinux.org>
References: <1272723382-19470-1-git-send-email-orenl@cs.columbia.edu> <1272723382-19470-2-git-send-email-orenl@cs.columbia.edu> <20100501.151022.190375136.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100501.151022.190375136.davem@davemloft.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 01, 2010 at 03:10:22PM -0700, David Miller wrote:
>
>NO WAY, there is no way in the world you should post 100 patches
>at a time to any mailing list, especially those at vger.kernel.org
>that have thousands upon thousands of subscribers.
>
>Post only small, well contained, sets of patches at a time.  At most
>10 or so in one go.
>
>Do you realize how much mail traffic you generate by posting so many
>patches at one time, and how unlikely it is for anyone to actually
>sift through and review your patches after you've spammed them by
>posting so many at one time?
>
>A second infraction and I will have no choice but to block you at the
>SMTP level at vger.kernel.org so please do not do it again.

So I really agree with everything you said here, but I do wonder why you haven't
sent a similar rant about the often 100+ patchsets for the -stable series.  We  
are supposed to review those and follow up on them to be sure they're suitable  
for a stable release.

Or the 100+ emails about regressions from version to version.  Etc, etc.

I'm not saying you're wrong, but it does seem a bit odd that you choose to reply
to this one, and not the other umpteen cases I often see.  Maybe it isn't about 
the size or volume of the emails, and more about the fact that it's 100 patches 
to implement _one_ thing?  If so, then I don't really think it's about list
traffic at all...

josh
