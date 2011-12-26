Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab1LZJdd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 04:33:33 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50900 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647Ab1LZJd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 04:33:26 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 26 Dec 2011 18:32:07 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Glauber Costa <glommer@parallels.com>, davem@davemloft.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, cgroups@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Paul Menage <paul@paulmenage.org>, Greg Thelen <gthelen@google.com>,
        Johannes Weiner <jweiner@redhat.com>
Subject: Re: [PATCH] Partial revert
 "Basic kernel memory functionality for the Memory Controller"
Message-Id: <20111226183207.1c40b8f4.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20111222104339.GA8833@tiehlicka.suse.cz>
References: <1324543990-27784-1-git-send-email-glommer@parallels.com>
	<20111222104339.GA8833@tiehlicka.suse.cz>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Dec 2011 11:43:39 +0100
Michal Hocko <mhocko@suse.cz> wrote:

> On Thu 22-12-11 12:53:10, Glauber Costa wrote:
> > This reverts commit e5671dfae59b165e2adfd4dfbdeab11ac8db5bda.
> > 
> > After a follow up discussion with Michal, it was agreed it would
> > be better to leave the kmem controller with just the tcp files,
> > deferring the behavior of the other general memory.kmem.* files
> > for a later time, when more caches are controlled.
> 
> "Because generic kmem files are not used by tcp accounting and it is
> not clear how other slab caches would fit into the scheme."
> 
> > 
> > We are reverting the original commit so we can track the reference.
> > Part of the patch is kept, because it was used by the later tcp
> > code. Conflicts are shown in the bottom. init/Kconfig is removed from
> > the revert entirely.
> > 
> > Signed-off-by: Glauber Costa <glommer@parallels.com>
> > CC: Kirill A. Shutemov <kirill@shutemov.name>
> > CC: Paul Menage <paul@paulmenage.org>
> > CC: Greg Thelen <gthelen@google.com>
> > CC: Johannes Weiner <jweiner@redhat.com>
> > CC: Michal Hocko <mhocko@suse.cz>
> > CC: David S. Miller <davem@davemloft.net>
> 
> Acked-by: Michal Hocko <mhocko@suse.cz>
> 

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


