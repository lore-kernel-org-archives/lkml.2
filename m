Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318Ab0EZLKW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 07:10:22 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49385 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285Ab0EZLKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 07:10:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TWfl81xaW9dMVv+9NiG/Al1cmgct7Lxaw6A8RDMW1uW0QTouyKVJ+oiuDk0hgTt1QD
         yWId3DzHjTz0mHfymLR81oU1YKuvmNJ8hFNoBSjKGT1c13fyejavtj5KD+gDouij35LU
         YTnLKvD/Rs3MbasA+6bPWFiaRFs/WlmXWheTA=
Date: Wed, 26 May 2010 13:10:18 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH] tracing: Remove kmemtrace ftrace plugin
Message-ID: <20100526111017.GG5311@nowhere>
References: <4BFCE849.7090804@cn.fujitsu.com> <20100526101617.GA14286@infradead.org> <20100526101837.GC5311@nowhere> <20100526102446.GA757@infradead.org> <20100526103222.GD5311@nowhere> <20100526110320.GA27011@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100526110320.GA27011@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 07:03:20AM -0400, Christoph Hellwig wrote:
> On Wed, May 26, 2010 at 12:32:23PM +0200, Frederic Weisbecker wrote:
> > But which debugfs code? Nothing related to $(DEBUGFS)/tracing right?
> 
> Exactly.  Blktrace creates it's own files under $(DEBUGFS)/block when
> enabled through the old ioctls.


I see. So it has never been updated to support the ftrace plugin.
Fine then, lets remove it.

