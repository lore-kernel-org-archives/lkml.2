Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932605Ab1BYPGR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 10:06:17 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54208 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932287Ab1BYPGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 10:06:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UXuGyG6CV69r2ES2V64RJ1phJbctkR38535yOG4ORs2z8qRDxtfmfmX0rEHFTIlDZg
         ciuYotJcTHDvsYBk6yrWIpk5WcD6q9tVzi9X53vEycTc9ns3zL1BedEmBQC4WDm58PUd
         hxc5PZODpa79GITT0MWqLhvGtTjckT9vZXruU=
Date: Fri, 25 Feb 2011 16:06:07 +0100
From: Tejun Heo <tj@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jack Steiner <steiner@sgi.com>, yinghai@kernel.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL tip:x86/mm] fix incorrect NUMA distance table size
 calculation
Message-ID: <20110225150607.GN24828@htj.dyndns.org>
References: <20110225145759.GA1606@sgi.com>
 <20110225150339.GA29895@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110225150339.GA29895@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from the following branch to receive NUMA distance table
size fix.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git x86-mm

David Rientjes (1):
      x86-64, NUMA: Fix size of numa_distance array

 arch/x86/mm/numa_64.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

Thanks.

-- 
tejun
