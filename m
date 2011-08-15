Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695Ab1HOXUo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 19:20:44 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:35952 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351Ab1HOXUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 19:20:43 -0400
Date: Tue, 16 Aug 2011 01:20:39 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ben Blum <bblum@andrew.cmu.edu>
Cc: Oleg Nesterov <oleg@redhat.com>, NeilBrown <neilb@suse.de>,
        paulmck@linux.vnet.ibm.com, Paul Menage <menage@google.com>,
        Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][BUGFIX] cgroups: fix ordering of calls in
 cgroup_attach_proc
Message-ID: <20110815232037.GD29942@somewhere>
References: <20110727171101.5e32d8eb@notabene.brown>
 <20110727150710.GB5242@unix33.andrew.cmu.edu>
 <20110727234235.GA2318@linux.vnet.ibm.com>
 <20110728110813.7ff84b13@notabene.brown>
 <20110728062616.GC15204@unix33.andrew.cmu.edu>
 <20110728171345.67d3797d@notabene.brown>
 <20110729142842.GA8462@unix33.andrew.cmu.edu>
 <20110815184957.GA16588@redhat.com>
 <20110815225003.GB29942@somewhere>
 <20110815231156.GC6867@unix33.andrew.cmu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110815231156.GC6867@unix33.andrew.cmu.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 15, 2011 at 07:11:56PM -0400, Ben Blum wrote:
> Fix ordering of cgroup_task_migrate and attach_task in cgroup_attach_proc.
> 
> Signed-off-by: Ben Blum <bblum@andrew.cmu.edu>

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
