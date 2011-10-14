Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933250Ab1JNQhG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 12:37:06 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44452 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754730Ab1JNQhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 12:37:04 -0400
Date: Fri, 14 Oct 2011 09:36:59 -0700
From: Tejun Heo <tj@kernel.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, Andrew Vagin <avagin@parallels.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Glauber Costa <glommer@parallels.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Daniel Lezcano <dlezcano@fr.ibm.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [patch 1/5] proc: Introduce the Children: line in
 /proc/<pid>/status
Message-ID: <20111014163650.GA4294@google.com>
References: <20111014110416.552685686@openvz.org>
 <20111014110511.157239709@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111014110511.157239709@openvz.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 03:04:17PM +0400, Cyrill Gorcunov wrote:
> From: Pavel Emelyanov <xemul@parallels.com>
> 
> Although we can get the pids of some task's issue, this is just 
> more convenient to have them this way.
> 
> Signed-off-by: Pavel Emelyanov <xemul@parallels.com>
> Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>

I've already written this but this info is already available through
/proc.  Maybe having this is beneficial but I think it would be better
to concentrate on the minimal set for now.

Thanks.

-- 
tejun
