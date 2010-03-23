Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab0CWTFm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 15:05:42 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:48481 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220Ab0CWTFl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 15:05:41 -0400
MIME-Version: 1.0
In-Reply-To: <20100323182153.GA14800@8bytes.org>
References: <4BA796DF.7090005@redhat.com> <4BA7A406.9050203@redhat.com>
	 <20100322173400.GB15795@elte.hu> <4BA7B9E0.5080009@codemonkey.ws>
	 <20100322192739.GE21919@elte.hu> <4BA7C96D.2020702@redhat.com>
	 <4BA7E9D9.5060800@codemonkey.ws> <20100323140608.GJ1940@8bytes.org>
	 <4BA8EEDE.8070309@redhat.com> <20100323182153.GA14800@8bytes.org>
Date: Tue, 23 Mar 2010 15:05:38 -0400
Message-ID: <90eb1dc71003231205o623a67b5taf12f8305fc89eb9@mail.gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single 
	project
From: Javier Guerra Giraldez <javier@guerrag.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: Avi Kivity <avi@redhat.com>, Anthony Liguori <anthony@codemonkey.ws>,
       Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, ziteng.huang@intel.com,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Fr?d?ric Weisbecker" <fweisbec@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 23, 2010 at 2:21 PM, Joerg Roedel <joro@8bytes.org> wrote:
> On Tue, Mar 23, 2010 at 06:39:58PM +0200, Avi Kivity wrote:
>> So, two users can't have a guest named MyGuest each?  What about
>> namespace support?  There's a lot of work in virtualizing all kernel
>> namespaces, you're adding to that.
>
> This enumeration is a very small and non-intrusive feature. Making it
> aware of namespaces is easy too.

an outsider's comment: this path leads to a filesystem... which could
be a very nice idea.  it could have a directory for each VM, with
pseudo-files with all the guest's status, and even the memory it's
using.  perf could simply watch those files.   in fact, such a
filesystem could be the main userleve/kernel interface.

but i'm sure such a layour was considered (and rejected) very early in
the KVM design.  i don't think there's anything new to make it more
desirable than it was back then.


-- 
Javier
