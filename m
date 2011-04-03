Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751748Ab1DCGVj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 02:21:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34487 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751540Ab1DCGVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 02:21:38 -0400
Date: Sun, 3 Apr 2011 08:21:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        aarcange@redhat.com, avi@redhat.com, mtosatti@redhat.com,
        kvm@vger.kernel.org, joro@8bytes.org, penberg@cs.helsinki.fi,
        asias.hejun@gmail.com, gorcunov@gmail.com
Subject: Re: [ANNOUNCE] Native Linux KVM tool
Message-ID: <20110403062117.GA27121@elte.hu>
References: <1301592656.586.15.camel@jaguar>
 <4D978930.1000909@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4D978930.1000909@codemonkey.ws>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Anthony Liguori <anthony@codemonkey.ws> wrote:

> On 03/31/2011 12:30 PM, Pekka Enberg wrote:
> > Hi all,
> >
> > We’re proud to announce the native Linux KVM tool!
> 
> Neat!
> 
> As something of a lesson of history, I'd suggest picking a more unique name 
> while it's still a prototype :-)

I disagree, i find it pretty handy and intuitive to run 'kvm ./disk.img' to 
boot KVM and this particular tool name has not been taken yet either.

perf uses a similar concept: the kernel subsystem is generally called 'perf', 
and the (Linux specific) user-space tool is called 'perf' as well. It makes 
quite a bit of sense.

Thanks,

	Ingo
