Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251Ab0IARDB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 13:03:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2974 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753142Ab0IARC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 13:02:59 -0400
Date: Wed, 1 Sep 2010 13:27:43 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 5/5] KVM: MMU: lower the aduit frequency
Message-ID: <20100901162743.GA12870@amt.cnet>
References: <4C78FA00.8090606@cn.fujitsu.com>
 <4C7B867D.9080500@cn.fujitsu.com>
 <4C7B8759.60900@cn.fujitsu.com>
 <20100830154719.GB12707@amt.cnet>
 <4C7C687D.2000401@cn.fujitsu.com>
 <4C7E179D.6000405@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C7E179D.6000405@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 01, 2010 at 12:06:37PM +0300, Avi Kivity wrote:
>  On 08/31/2010 05:27 AM, Xiao Guangrong wrote:
> >
> >>I've always seen progress from the guest while running with audit
> >>enabled (its slow, but its not supposed to be fast anyway).
> >>
> >>Did you experience a freeze?
> >>
> >There is a simply test in the guest if it's not rate limit:
> >
> ># time ls
> >anaconda-ks.cfg  Documents  install.log         Music     Public     Videos
> >Desktop          Downloads  install.log.syslog  Pictures  Templates
> >
> >real    1m26.053s
> >user    0m0.311s
> >sys     0m1.813s
> >
> >'ls' command cost about 1.5 minute, if we run the memory test program, i think
> >the time/delay is unacceptable...... :-(
> 
> Marcelo, would making the ratelimit optional help?  personally I
> think without ratelimit audit is useless, and with ratelimit it is a
> lot less useful but can still point out problems.  But I haven't
> used it in a while.

Was just wondering whether there was a freeze. Patchset looks good
(ratelimit can be disabled manually).

