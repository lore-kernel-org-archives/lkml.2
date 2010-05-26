Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283Ab0EZKSn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 06:18:43 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62830 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757159Ab0EZKSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 06:18:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=aG+rbdqKS48HbKWcjBn6fL3cIctSX+LAEwaBUpI98k3p/j7KI5auJuimFbAum7FSNc
         GYBUGsdDSQWR+60FIksgHmF8Sc2W6gneQ7q5M5YkCO7ThJWQwcIFQUMasrZNVTrWKE4u
         ZP4L3qfo/XxiJH627jPmHFC8YGxaI9sR9lGOc=
Date: Wed, 26 May 2010 12:18:38 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH] tracing: Remove kmemtrace ftrace plugin
Message-ID: <20100526101837.GC5311@nowhere>
References: <4BFCE849.7090804@cn.fujitsu.com> <20100526101617.GA14286@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100526101617.GA14286@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 06:16:17AM -0400, Christoph Hellwig wrote:
> On Wed, May 26, 2010 at 05:22:17PM +0800, Li Zefan wrote:
> > We have been resisting new ftrace plugins and removing existing
> > ones, and kmemtrace has been superseded by kmem trace events
> > and perf-kmem, so we remove it.
> 
> While you're at it also care to remove the blk ftrace plugin?  We have
> the old blktrace ioctl interface and the trace events as better
> alternatives.


But does the userspace tool support them?

