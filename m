Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662Ab1FIWBj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 18:01:39 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54491 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756427Ab1FIWBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 18:01:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=szeredi.hu; s=google;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=TK41fgzZzVRFrTkfMnt0WrYbY28BuBl+phFG0aeiic0Up3DVVXuzOP4JafDrTqsJrp
         +QpeM/wCjmrtVW0XxqIp50HtnG60NzLmhqg+9Hi7kpYJbuy9O6Urkfu/2chD+XrxGlS1
         LUrLebeiL7a58PFwmRBkLAscpLFtu6DUB9KgA=
From: Miklos Szeredi <miklos@szeredi.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: NeilBrown <neilb@suse.de>, viro@ZenIV.linux.org.uk,
        torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, apw@canonical.com, nbd@openwrt.org,
        hramrach@centrum.cz, jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu,
        hooanon05@yahoo.co.jp
Subject: Re: [PATCH 0/7] overlay filesystem: request for inclusion
References: <1306932380-10280-1-git-send-email-miklos@szeredi.hu>
	<20110608153208.dc705cda.akpm@linux-foundation.org>
	<20110609115934.3c53f78f@notabene.brown>
	<20110608205233.ebfedc4d.akpm@linux-foundation.org>
	<87wrgvb28a.fsf@tucsk.pomaz.szeredi.hu>
	<20110609123843.77153b27.akpm@linux-foundation.org>
Date: Fri, 10 Jun 2011 00:02:05 +0200
In-Reply-To: <20110609123843.77153b27.akpm@linux-foundation.org> (Andrew
	Morton's message of "Thu, 9 Jun 2011 12:38:43 -0700")
Message-ID: <877h8uzmsi.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

>> > Well, these things have been around for over 20 years.  What motivated
>> > the developers of other OS's to develop these things and how are their
>> > users using them?
>> 
>> That's a good question, Erez might be able to answer that better.
>> 
>> We have customers who need this for the "common base + writable
>> configuration" case in a virtualized environment.
>> 
>> Since overlayfs's announcement several projects have tried it and have
>> been very good testers and bug reporters.  These include OpenWRT, Ubuntu
>> and other Debian based live systems.
>
> I assume that the live CD was your motivator for developing overlayfs?

Actually no.  The main motivator was that I started reviewing
union-mounts and got thinking about how to do it better.

>> > Another issue: there have been numerous attempts at Linux overlay
>> > filesystems from numerous parties.  Does (or will) this implementation
>> > satisfy all their requirements?
>> 
>> Overlayfs aims to be the simplest possible but not simpler.
>> 
>> I think the reason why "aufs" never had a real chance at getting merged
>> is because of feature creep.
>> 
>> Of course I expect new features to be added to overlayfs after the
>> merge, but I beleive some of the features in those other solutions are
>> simply unnecessary.
>
> This is my main worry.  If overlayfs doesn't appreciably decrease the
> motivation to merge other unioned filesystems then we might end up with
> two similar-looking things.  And, I assume, the later and more
> fully-blown implementation might make overlayfs obsolete but by that
> time it will be hard to remove.
>
> So it would be interesting to hear the thoughts of the people who have
> been working on the other implementations.

Added J. R. Okajima (aufs maintainer) to CC.

Thanks,
Miklos
