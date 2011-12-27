Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab1L0K3D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 05:29:03 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:58437 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631Ab1L0K3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 05:29:01 -0500
From: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, peterz@infradead.org,
        linux-kernel@vger.kernel.org, vatsa@linux.vnet.ibm.com,
        bharata@linux.vnet.ibm.com
Subject: Re: [RFC PATCH 0/4] Gang scheduling in CFS
In-Reply-To: <4EF98CB4.2050408@redhat.com>
References: <20111219083141.32311.9429.stgit@abhimanyu.in.ibm.com> <20111219112326.GA15090@elte.hu> <87sjke1a53.fsf@abhimanyu.in.ibm.com> <4EF1B85F.7060105@redhat.com> <877h1o9dp7.fsf@linux.vnet.ibm.com> <20111223103620.GD4749@elte.hu> <4EF701C7.9080907@redhat.com> <87vcp4t45p.fsf@linux.vnet.ibm.com> <4EF838BD.60406@redhat.com> <87d3bbtvnw.fsf@linux.vnet.ibm.com> <4EF85D50.8000204@redhat.com> <87aa6eu6o8.fsf@linux.vnet.ibm.com> <4EF98CB4.2050408@redhat.com>
User-Agent: Notmuch/0.10.2+70~gf0e0053 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-redhat-linux-gnu)
Date: Tue, 27 Dec 2011 15:54:42 +0530
Message-ID: <87lipyia6t.fsf@abhimanyu.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 11122710-4790-0000-0000-000000978C44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Dec 2011 11:15:32 +0200, Avi Kivity <avi@redhat.com> wrote:
> On 12/27/2011 03:47 AM, Nikunj A Dadhania wrote:
[...]
> > Though in the guest dmesg, I still do not see any x2apic logs. I am
> > missing something obvious here. 
> >
> 
> Check that X2APIC is enabled in the guest .config, as well as
> CONFIG_KVM_GUEST.
> 
X2APIC is not enabled
CONFIG_KVM_GUEST is enabled.
Its a 2.6.32 based distro kernel.

Nikunj

