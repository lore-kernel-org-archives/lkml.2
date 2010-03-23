Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688Ab0CWS1T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 14:27:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44421 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab0CWS1R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 14:27:17 -0400
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
From: Peter Zijlstra <peterz@infradead.org>
To: Joerg Roedel <joro@8bytes.org>
Cc: Avi Kivity <avi@redhat.com>, Anthony Liguori <anthony@codemonkey.ws>,
       Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, ziteng.huang@intel.com,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>
In-Reply-To: <20100323182153.GA14800@8bytes.org>
References: <4BA796DF.7090005@redhat.com> <20100322165107.GD18796@elte.hu>
	 <4BA7A406.9050203@redhat.com> <20100322173400.GB15795@elte.hu>
	 <4BA7B9E0.5080009@codemonkey.ws> <20100322192739.GE21919@elte.hu>
	 <4BA7C96D.2020702@redhat.com> <4BA7E9D9.5060800@codemonkey.ws>
	 <20100323140608.GJ1940@8bytes.org> <4BA8EEDE.8070309@redhat.com>
	 <20100323182153.GA14800@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 23 Mar 2010 19:27:04 +0100
Message-ID: <1269368824.5109.159.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-23 at 19:21 +0100, Joerg Roedel wrote:

> Sidenote: I really think we should come to a conclusion about the
>           concept. KVM integration into perf is very useful feature to
> 	  analyze virtualization workloads.

I always start my things with bare kvm, It would be very unwelcome to
mandate libvirt, or for that matter running a particular userspace in
the guest.
