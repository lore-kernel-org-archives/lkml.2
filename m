Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928Ab0DUQLh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 12:11:37 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:43866 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755879Ab0DUQLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 12:11:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vXu72Fu33oNsBg6xDKMwVM6b4nwMoMeSzn8raEAPl01Mv2uoDhsvForAQynqt5Fc6n
         Wvx9aXwMuM/gbH8RVpFwG4G2PXTRRiPiTn6yjmgCU2SlgGkH17M7pPjmZk42anPKkcZs
         Ppo2wYd98/ydFV21ROt8Gqy876QpKTLRD93mM=
Date: Wed, 21 Apr 2010 18:11:38 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "David S . Miller" <davem@davemloft.net>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>, Li Zefan <lizf@cn.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [GIT PULL] tracing update
Message-ID: <20100421161136.GB5650@nowhere>
References: <1271706114-8489-1-git-send-regression-fweisbec@gmail.com> <20100421074917.GB17237@elte.hu> <20100421080544.GA13107@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100421080544.GA13107@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21, 2010 at 10:05:44AM +0200, Ingo Molnar wrote:
> 
> > > Frederic Weisbecker (1):
> > >       tracing: Dump either the oops's cpu source or all cpus buffers
> 
> FYI, it has build failures on x86:
> 
>  kernel/trace/trace.c:4412: error: conflicting types for '__ftrace_dump'
>  kernel/trace/trace_selftest.c:258: note: previous declaration of '__ftrace_dump' was here


Oops, fix coming soon.

Thanks.

