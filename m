Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226Ab1HYSNi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 14:13:38 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57727 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716Ab1HYSNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 14:13:36 -0400
Date: Thu, 25 Aug 2011 22:13:31 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Nathan Lynch <ntl@pobox.com>, Oren Laadan <orenl@cs.columbia.edu>,
        Daniel Lezcano <dlezcano@fr.ibm.com>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>, linux-kernel@vger.kernel.org,
        James Bottomley <jbottomley@parallels.com>,
        LINUXFS-ML <linux-fsdevel@vger.kernel.org>, containers@lists.osdl.org,
        Zan Lynx <zlynx@acm.org>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC] fs, proc: Introduce the /proc/<pid>/map_files/ directory v2
Message-ID: <20110825181331.GG6387@sun>
References: <20110824085329.GL29452@sun>
 <20110824111806.GA7191@albatros>
 <20110825082944.GH10030@sun>
 <20110825173642.GA3288@albatros>
 <20110825173953.GE6387@sun>
 <20110825175438.GA3739@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110825175438.GA3739@albatros>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 09:54:38PM +0400, Vasiliy Kulikov wrote:
...
> > > 
> > 
> > Don't think so, it should point that permission failed
> > rather no such entry. Or this might break some tools?
> 
> I mean the place exactly where I've put it to indicate simple_strtoul(),
> get_task_mm(), or find_exact_vma() error.  EPERM for ptrace_may_access()
> is OK.
> 

Ah, yeah! ENOENT is really would be correct option here, will fix in next
iteration, thanks a huge for spotting it!

	Cyrill
