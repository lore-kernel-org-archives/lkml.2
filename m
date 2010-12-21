Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826Ab0LUNNV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 08:13:21 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:49222 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab0LUNNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 08:13:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DlIMjSEpCvL3twf0JN+Ed5DXxWbhPQ/ENnNNsmDIZlUN6NNiBP3VcHQqsz4Q5zGiGn
         9pxiDM1G5mhd/RaeqN/6YJsHRVtPU4Em8WeJ2Qk8rfmwFXI/jpVvOdb0VJwlZxRssUMJ
         yCv+/J51wtqRodW3nR9c6UuTKCFdZHgAkb7o0=
Date: Tue, 21 Dec 2010 14:13:15 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 00/15] Nohz task support
Message-ID: <20101221131311.GA1750@nowhere>
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
 <1292859886.22905.22.camel@gandalf.stny.rr.com>
 <20101220233341.GA1715@nowhere>
 <1292916878.5021.170.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292916878.5021.170.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 21, 2010 at 08:34:38AM +0100, Peter Zijlstra wrote:
> On Tue, 2010-12-21 at 00:33 +0100, Frederic Weisbecker wrote:
> > So, we still need the syscalls slow path hooks.
> 
> Make it a cpuset property or something.

Hm, but I don't understand how cpusets can help about that.

You mean I could use cpuset to define a range of cpus on which
I can run nohz tasks? And then set the TIF flags on those threads
and so?
