Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab2AQMBF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 07:01:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35605 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753142Ab2AQMA2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 07:00:28 -0500
Date: Tue, 17 Jan 2012 09:59:13 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Stefan Hajnoczi <stefanha@gmail.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 3/3] KVM: perf: kvm events analysis tool
Message-ID: <20120117115913.GC17420@amt.cnet>
References: <4F13EE3D.2070602@linux.vnet.ibm.com>
 <4F13EEC5.8050807@linux.vnet.ibm.com>
 <CAJSP0QVxR9sYYh_Vr6ZKAU-YrWpjgL5jpiKz2zt7eJxV_kgaOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJSP0QVxR9sYYh_Vr6ZKAU-YrWpjgL5jpiKz2zt7eJxV_kgaOg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 10:08:40AM +0000, Stefan Hajnoczi wrote:
> On Mon, Jan 16, 2012 at 9:32 AM, Xiao Guangrong
> <xiaoguangrong@linux.vnet.ibm.com> wrote:
> > +DESCRIPTION
> > +-----------
> > +You can analyze some crucial events and statistics with this
> > +'perf kvm-events' command.
> 
> This line is very general and does not explain which events/statistics
> can be collected or how you can use that information.  I suggest
> making this description more specific.  Explain that this subcommand
> observers kvm.ko tracepoints and annotates/decodes them with
> additional information (this is why I would use this command and not
> raw perf record -e kvm:\*).
> 
> > +       { SVM_EXIT_MONITOR,                     "monitor" }, \
> > +       { SVM_EXIT_MWAIT,                       "mwait" }, \
> > +       { SVM_EXIT_XSETBV,                      "xsetbv" }, \
> > +       { SVM_EXIT_NPF,                         "npf" }
> 
> All this copy-paste could be avoided by sharing this stuff with the
> arch/x86/kvm/ code.

Yes, same for KVM_MAX_VCPUS.

