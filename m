Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205Ab2BPQgA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 11:36:00 -0500
Received: from casper.infradead.org ([85.118.1.10]:33304 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836Ab2BPQf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 11:35:59 -0500
Date: Thu, 16 Feb 2012 14:35:39 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: David Ahern <dsahern@gmail.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 3/3] KVM: perf: kvm events analysis tool
Message-ID: <20120216163539.GC2086@infradead.org>
References: <j8pru203h6n22hdd9bryyyfr.1329110982240@email.android.com>
 <4F38E091.5070504@linux.vnet.ibm.com>
 <4F3931D6.2090305@gmail.com>
 <4F3C8D3F.9010105@linux.vnet.ibm.com>
 <4F3C8E84.80905@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F3C8E84.80905@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Feb 15, 2012 at 10:05:08PM -0700, David Ahern escreveu:
> On 2/15/12 9:59 PM, Xiao Guangrong wrote:
> >
> >
> >Okay, i will post the next version after collecting your new comments!
> >
> >Thanks for your time, David! :)
> >
> 
> I had more comments, but got sidetracked and forgot to come back to
> this. I still haven't looked at the code yet, but some comments from
> testing:
> 
> 1. The error message:
>   Warning: Error: expected type 5 but read 4
>   Warning: Error: expected type 5 but read 0
>   Warning: unknown op '}'
> 
> is fixed by this patch which has not yet made its way into perf:
> https://lkml.org/lkml/2011/9/4/41
> 
> The most recent request:
> https://lkml.org/lkml/2012/2/8/479
> 
> Arnaldo: the patch still applies cleanly (but with an offset of -2 lines).

I'll merge this one now, recall Steven asked me to, thanks for the
reminder,

- Arnaldo
