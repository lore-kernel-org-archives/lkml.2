Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933318Ab1JNQnk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 12:43:40 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56723 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755086Ab1JNQnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 12:43:39 -0400
Date: Fri, 14 Oct 2011 20:43:33 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andrew Vagin <avagin@parallels.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Glauber Costa <glommer@parallels.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Daniel Lezcano <dlezcano@fr.ibm.com>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [patch 3/5] fs, proc: Add /proc/$pid/tls entry
Message-ID: <20111014164333.GU14464@moon>
References: <20111014110416.552685686@openvz.org>
 <20111014110511.416851818@openvz.org>
 <20111014164050.GB4294@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111014164050.GB4294@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 09:40:50AM -0700, Tejun Heo wrote:
> On Fri, Oct 14, 2011 at 03:04:19PM +0400, Cyrill Gorcunov wrote:
> > To be able to restart checkpointed tasks we need
> > to know TLS status at dumping time. Export this
> > information by /proc/$pid/tls entry.
> > 
> > Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> 
> No objection from me but it would be great if you can go over other
> archs and see how other archs deal with tls just in case.
> 

I'll check, at moment I found it at x86 only (in thread_info) but definitely
need to re-check. Thanks Tejun!

	Cyrill
