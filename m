Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933886Ab2FELJd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 07:09:33 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:34189 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892Ab2FELJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 07:09:32 -0400
From: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "peterz\@infradead.org" <peterz@infradead.org>,
        "mingo\@elte.hu" <mingo@elte.hu>,
        "mtosatti\@redhat.com" <mtosatti@redhat.com>,
        "avi\@redhat.com" <avi@redhat.com>,
        "raghukt\@linux.vnet.ibm.com" <raghukt@linux.vnet.ibm.com>,
        "kvm\@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86\@kernel.org" <x86@kernel.org>,
        "jeremy\@goop.org" <jeremy@goop.org>,
        "vatsa\@linux.vnet.ibm.com" <vatsa@linux.vnet.ibm.com>,
        "hpa\@zytor.com" <hpa@zytor.com>
Subject: Re: [PATCH v2 6/7] kvm,x86: RCU based table free
In-Reply-To: <alpine.DEB.2.02.1206051137270.6030@kaball.uk.xensource.com>
References: <20120604050223.4560.2874.stgit@abhimanyu.in.ibm.com> <20120604050822.4560.54662.stgit@abhimanyu.in.ibm.com> <alpine.DEB.2.02.1206051137270.6030@kaball.uk.xensource.com>
User-Agent: Notmuch/0.10.2+70~gf0e0053 (http://notmuchmail.org) Emacs/24.0.95.1 (x86_64-unknown-linux-gnu)
Date: Tue, 05 Jun 2012 16:38:47 +0530
Message-ID: <87ehpuqam8.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
x-cbid: 12060511-8256-0000-0000-000002CD99BB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jun 2012 11:48:02 +0100, Stefano Stabellini <stefano.stabellini@eu.citrix.com> wrote:
> 
> I am also interested in introducing HAVE_RCU_TABLE_FREE on x86 for Xen.
> Maybe we can pull our efforts together :-)
> 
> Giving a look at this patch, it doesn't look like it is introducing
> CONFIG_HAVE_RCU_TABLE_FREE anywhere under arch/x86.
> How is the user supposed to set it?
>
I am doing that in the next patch only for KVM-ParavirtTLB flush, as
there is a bug in this implementation that patch [7/7] fixes.

Refer following thread for details:
http://mid.gmane.org/1337254086.4281.26.camel@twins
http://mid.gmane.org/1337273959.4281.62.camel@twins

Regards
Nikunj

