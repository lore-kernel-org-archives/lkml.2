Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227Ab1JNMPz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 08:15:55 -0400
Received: from mail-wy0-f180.google.com ([74.125.82.180]:65031 "EHLO
	mail-wy0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab1JNMPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 08:15:54 -0400
Date: Fri, 14 Oct 2011 14:15:49 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ben Blum <bblum@andrew.cmu.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, NeilBrown <neilb@suse.de>,
        paulmck@linux.vnet.ibm.com, Paul Menage <paul@paulmenage.org>,
        Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        Balbir Singh <bsingharora@gmail.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 1/2] cgroups: use sighand lock instead of tasklist_lock
 in cgroup_attach_proc
Message-ID: <20111014121547.GK14968@somewhere>
References: <20110727171101.5e32d8eb@notabene.brown>
 <20110727150710.GB5242@unix33.andrew.cmu.edu>
 <20110727234235.GA2318@linux.vnet.ibm.com>
 <20110728110813.7ff84b13@notabene.brown>
 <20110728062616.GC15204@unix33.andrew.cmu.edu>
 <20110728171345.67d3797d@notabene.brown>
 <20110729142842.GA8462@unix33.andrew.cmu.edu>
 <20110815184957.GA16588@redhat.com>
 <20111014003115.GB22527@ghc17.ghc.andrew.cmu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111014003115.GB22527@ghc17.ghc.andrew.cmu.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

On Thu, Oct 13, 2011 at 08:31:15PM -0400, Ben Blum wrote:
> Use sighand lock instead of tasklist_lock in cgroup_attach_proc.

Could you please feed more the changelog to explain the reason of
the change? Well, the reason of converting tasklist_lock based locking to
something more granular is almost obvious these days, but
it would be nice to know why it is safe to do so. And what exactly
that protects.

Thanks.
