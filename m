Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584Ab1BGERz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 23:17:55 -0500
Received: from 184-106-158-135.static.cloud-ips.com ([184.106.158.135]:33158
	"EHLO mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754356Ab1BGERx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 23:17:53 -0500
Date: Mon, 7 Feb 2011 04:18:39 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: containers@lists.linux-foundation.org,
        linux-security-module@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>, libvir-list@redhat.com,
        Dan Smith <danms@us.ibm.com>
Subject: if you use user namespaces
Message-ID: <20110207041839.GA25871@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please let me know.  lxc does not use them right now.  Libvirt uses them
for lxc containers f they are available, but I hope we can essentially
have it stop for awhile.  In addition, there's tons of software out
there that I don't know about, and fear of breaking their use of current
user namespaces has been keeping me from pushing further userns patches.

I've outlined how I see user namespaces developing at
https://wiki.ubuntu.com/UserNamespace .  Note there is nothing new
in there - some of it goes a year back, much of it more than two
years.  Nothing actually new.

Currently user namespaces are not very useful, but they do provide
separate uid accounting, and simply tossing CLONE_NEWUSER in with
CLONE_NEWNS and friends has until now been safe to do.  As you can
see, that is going to change.  So if that would cause you pain that
you can't work around, please get back to me.  Otherwise, I'd like
to get serious soon about expanding upon, and pushing upstream, the
patches to make CLONE_NEWUSER more useful for sandboxing.

thanks,
-serge
