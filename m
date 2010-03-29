Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535Ab0C2BAw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 21:00:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:41229 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755502Ab0C2BAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 21:00:51 -0400
Message-ID: <4BAFFBBC.5040402@kernel.org>
Date: Mon, 29 Mar 2010 10:00:44 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       lkml <linux-kernel@vger.kernel.org>
Subject: [GIT PULL linux-next] break implicit percpu.h -> slab.h dependency
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 29 Mar 2010 01:00:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Stephen.

Can you please pull the following into linux-next?

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git slabh

The tree breaks implicit slab.h inclusion from percpu.h.  It turned
out that a lot of .c files assumed slab/gfp availability w/o actually
including the respective header, so the conversion ended up modifying
includes on over 4000 files.

I don't expect there to be a lot of conflicts and the ones which
happen should be straight forward to resolve.  Albeit large in volume,
the changes being mostly trivial, I'm hoping to push this into Linus
tree soonish (ie. during this devel cycle), so the tree hopefully will
go away soon.

Please read the following thread for details.

 http://thread.gmane.org/gmane.linux.kernel/965549

Thank you.

-- 
tejun
