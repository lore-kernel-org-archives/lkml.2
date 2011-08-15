Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543Ab1HONjG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 09:39:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61504 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752720Ab1HONjD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 09:39:03 -0400
Message-ID: <4E49215A.5080103@redhat.com>
Date: Mon, 15 Aug 2011 06:38:34 -0700
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, Jay Ren <yongjie.ren@intel.com>,
        stefanha@linux.vnet.ibm.com, KVM General <kvm@vger.kernel.org>
Subject: Re: [Bug #39412] Win Vista and Win2K8 guests' network breaks down
References: <xuTC4jRtHbB.A.l4H.gMCSOB@chimera> <bkwpSnItbJM.A.nx.VNCSOB@chimera> <CAOJsxLEToaQe3DrhUQx5FizMnzATxwG8XGCPwZpRFpuBQpq1ug@mail.gmail.com>
In-Reply-To: <CAOJsxLEToaQe3DrhUQx5FizMnzATxwG8XGCPwZpRFpuBQpq1ug@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2011 03:33 AM, Pekka Enberg wrote:
> On Sun, Aug 14, 2011 at 10:07 PM, Rafael J. Wysocki<rjw@sisk.pl>  wrote:
> >  This message has been generated automatically as a part of a report
> >  of regressions introduced between 2.6.39 and 3.0.
> >
> >  The following bug entry is on the current list of known regressions
> >  introduced between 2.6.39 and 3.0.  Please verify if it still should
> >  be listed and let the tracking team know (either way).
> >
> >
> >  Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=39412
> >  Subject         : Win Vista and Win2K8 guests' network breaks down
> >  Submitter       : Jay Ren<yongjie.ren@intel.com>
> >  Date            : 2011-07-15 15:31 (31 days old)
>
> The bugzilla report claims that this commit fixes the regression:
>
> http://git.kernel.org/?p=virt/kvm/kvm.git;a=commitdiff;h=e72ef590a3ef3047f6ed5bcb8808a9734f6c4b32
>
> The commit, however, is not in mainline nor does it seem to be tagged
> for -stable.

That commit is completely unrelated.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

