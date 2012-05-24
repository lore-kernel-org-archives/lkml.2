Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934018Ab2EXSCW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 14:02:22 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:40613 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933532Ab2EXSCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 14:02:18 -0400
Date: Thu, 24 May 2012 11:01:21 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>, ebiederm@xmission.com,
        tj@kernel.org, skinsbursky@openvz.org
Subject: Re: [rfc v2 0/7] procfs fdinfo extension v2
Message-ID: <20120524180121.GK798@count0.beaverton.ibm.com>
References: <20120523102541.382837149@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120523102541.382837149@openvz.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12052418-1780-0000-0000-000005DB5F3C
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000277; HX=3.00000188; KW=3.00000007;
 PH=3.00000001; SC=3.00000002; SDB=6.00142019; UDB=6.00032768; UTC=2012-05-24
 18:02:16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 02:25:41PM +0400, Cyrill Gorcunov wrote:

<snip>

>  - finally it would be great to have ability to attach tasks to
>    frozen tasks cgroup to thaw them at one moment (the preliminary
>    patch I've proposed pretty long ago, but Tejun was modifying cgroups
>    code and asked to wait until 3.4 is release, so I didn't check
>    the current status of task cgroups at moment, I've it in my todo list)

This still strikes me as the wrong way to go about freezing for c/r.
You never explained why you had to do it this way. Why can't you inject
the parasite thread, move that thread out of the cgroup-to-be-frozen,
then freeze?

As best I can tell your reply last time only fleshed out the details
of *how* you would like it to work, not *why it needs to* work that way:

	http://lkml.org/lkml/2011/11/30/27

Cheers,
	-Matt Helsley

