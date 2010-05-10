Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296Ab0EJFLI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 01:11:08 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:40568 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621Ab0EJFLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 01:11:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MJ/RKn3vIjEcV9UjHjMqcJuwlzZhO6cOjRB6CL4YGXrvVYCdZ4cvDCdAkY4JZ27gLL
         qK0sOXDp4NTBLaOfpNPiz5TDqQsE3ulusUymmFBOLYO0Y5GTAlghuW1BYY2Bys2YqOa3
         x6IA2EoiVW5ZyRobrDemg2T2FdAR1kmsNv2pY=
Date: Mon, 10 May 2010 07:10:53 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>, Jason Baron <jbaron@redhat.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [GIT PULL] perf updates
Message-ID: <20100510051048.GA5448@nowhere>
References: <1273437818-8130-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273437818-8130-1-git-send-regression-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 09, 2010 at 10:43:28PM +0200, Frederic Weisbecker wrote:
> Ingo,
> 
> Please pull the perf/test branch that can be found at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> 	perf/test


It's for tip:perf/core btw.

