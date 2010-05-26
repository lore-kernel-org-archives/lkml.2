Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351Ab0EZKc2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 06:32:28 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63020 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab0EZKc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 06:32:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pA80xg1aQlOIwiBu7/Q6Ts8f1AaZmkzauD2Y4YzD3wkxli6ZrN6G8g+lKIYmZHdfsO
         094cki5CoB0ajxl9MTRhUafDrgaufX0pOyKvw7nB2kPh8l+1cd2Aq22M7lUa8hs64CDh
         n0761cLXyNiDaM6yTHoBNIzuRK/UNuhhXioEU=
Date: Wed, 26 May 2010 12:32:23 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH] tracing: Remove kmemtrace ftrace plugin
Message-ID: <20100526103222.GD5311@nowhere>
References: <4BFCE849.7090804@cn.fujitsu.com> <20100526101617.GA14286@infradead.org> <20100526101837.GC5311@nowhere> <20100526102446.GA757@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100526102446.GA757@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 06:24:46AM -0400, Christoph Hellwig wrote:
> On Wed, May 26, 2010 at 12:18:38PM +0200, Frederic Weisbecker wrote:
> > But does the userspace tool support them?
> 
> The blktrace userspace tool only uses the ioctl/debugfs code.
> 


But which debugfs code? Nothing related to $(DEBUGFS)/tracing right?

