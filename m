Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674Ab1FFXsX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 19:48:23 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:61473 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798Ab1FFXsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 19:48:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tXc/oHceppDUMIdWWiZC8JeAoCc2gV1QRmzLBBhz0eL46Sscr+tUsWdz6+Z//8e5w5
         Zcd7OiR+67CrLZfzz4j9yIp7M6I8f2vCpwujFA/uXisrrLNXoFKFKVvSRvzUA072tHAt
         YhPlkjvQMR8NLXISofjyt8C5WOYEVz15jLg/c=
Date: Tue, 7 Jun 2011 01:48:17 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Sam Ravnborg <sam@ravnborg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4] Make CONFIG_EXPERT select CONFIG_DEBUG_KERNEL to
 unhide debug options
Message-ID: <20110606234816.GD17026@somewhere.redhat.com>
References: <20110605210223.GA7595@leaf>
 <20110606151832.GI30348@elte.hu>
 <20110606165130.GA1844@leaf>
 <20110606181606.GB7862@somewhere>
 <20110606183939.GA2335@leaf>
 <20110606220810.GA1999@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110606220810.GA1999@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 06, 2011 at 03:08:10PM -0700, Josh Triplett wrote:
> Several debugging options currently default to y, such as
> CONFIG_DEBUG_BUGVERBOSE and CONFIG_DEBUG_RODATA.  Embedded users might
> want to turn those options off to save space; however, turning them off
> requires turning on CONFIG_DEBUG_KERNEL to unhide them.  Since
> CONFIG_DEBUG_KERNEL exists specifically to unhide debugging options, and
> CONFIG_EXPERT exists specifically to unhide options potentially needed
> by experts and/or embedded users, make CONFIG_EXPERT automatically imply
> CONFIG_DEBUG_KERNEL.
> 
> Since EXPERT now implies DEBUG_KERNEL, change debugging options that
> reference DEBUG_KERNEL && EXPERT to just reference EXPERT.
> 
> Signed-off-by: Josh Triplett <josh@joshtriplett.org>

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

Ingo, is it possible to zap the old one from the tree and apply this one
instead?

Or may be Josh can send an incremental patch instead (I just feel bad in advance to
ask him for a v5 :)
