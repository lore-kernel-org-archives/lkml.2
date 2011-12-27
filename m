Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001Ab1L0Bvu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 20:51:50 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:43070 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab1L0Bvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 20:51:45 -0500
From: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, peterz@infradead.org,
        linux-kernel@vger.kernel.org, vatsa@linux.vnet.ibm.com,
        bharata@linux.vnet.ibm.com
Subject: Re: [RFC PATCH 0/4] Gang scheduling in CFS
In-Reply-To: <4EF85D50.8000204@redhat.com>
References: <20111219083141.32311.9429.stgit@abhimanyu.in.ibm.com> <20111219112326.GA15090@elte.hu> <87sjke1a53.fsf@abhimanyu.in.ibm.com> <4EF1B85F.7060105@redhat.com> <877h1o9dp7.fsf@linux.vnet.ibm.com> <20111223103620.GD4749@elte.hu> <4EF701C7.9080907@redhat.com> <87vcp4t45p.fsf@linux.vnet.ibm.com> <4EF838BD.60406@redhat.com> <87d3bbtvnw.fsf@linux.vnet.ibm.com> <4EF85D50.8000204@redhat.com>
User-Agent: Notmuch/0.10.2+70~gf0e0053 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-redhat-linux-gnu)
Date: Tue, 27 Dec 2011 07:17:35 +0530
Message-ID: <87aa6eu6o8.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 11122701-3864-0000-0000-000000AEB849
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Dec 2011 13:41:04 +0200, Avi Kivity <avi@redhat.com> wrote:
> On 12/26/2011 01:33 PM, Nikunj A Dadhania wrote:
> 
> > I have enabled the following in my config;
> >
> > [root@krm1 linux-tip]# grep X2APIC .config
> > CONFIG_X86_X2APIC=y
> > [root@krm1 linux-tip]#
> >
> > And booted the kernel with "apic=verbose" command. 
> >
> > [root@krm1 linux-tip]# dmesg | grep -i x2apic
> > [root@krm1 linux-tip]# 
> >
> > Does not give anything. I safely assumed that x2apic is not
> > supported. Is there something to do in the bios to enable this?
> 
> Sorry, I was imprecise.  Boot the guest, it will recognize the emulated
> x2apic.
>
I booted the guest with -cpu ...,+x2apic (using libvirt), and verified
that qemu command-line does contain x2apic.

There is a log saying this:

Using CPU model
"Nehalem,+rdtscp,+x2apic,+dca,+xtpr,+tm2,+est,+vmx,+ds_cpl,+monitor,+pbe,+tm,+ht,+ss,+acpi,+ds,+vme"
 
Though in the guest dmesg, I still do not see any x2apic logs. I am
missing something obvious here. 

Regards
Nikunj

