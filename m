Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445Ab1KUWQm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 17:16:42 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:60636 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755692Ab1KUWQj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 17:16:39 -0500
MIME-Version: 1.0
In-Reply-To: <87lira9ii7.fsf@rustcorp.com.au>
References: <20111108214452.28884.14840.stgit@miche.sea.corp.google.com>
	<20111108214504.28884.61814.stgit@miche.sea.corp.google.com>
	<874nybqo0o.fsf@rustcorp.com.au>
	<CAB8RdapbaueyWLJuJDE_ZdvLkRNM4sQHTxgmgO=jrnXZ6YPSmA@mail.gmail.com>
	<87lira9ii7.fsf@rustcorp.com.au>
Date: Mon, 21 Nov 2011 14:16:38 -0800
Message-ID: <CAB8Rdaqno9kVHB8wsbH5=zs_ppUkd1G=siywFFfH3Ud21qK3FA@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] hvc_init(): Enforce one-time initialization.
From: Miche Baker-Harvey <miche@google.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>, xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Anton Blanchard <anton@samba.org>, Amit Shah <amit.shah@redhat.com>,
        Mike Waychison <mikew@google.com>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Eric Northrup <digitaleric@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, Rusty.  I'm not using QEMU though, just KVM.   I create the device, wait
for the message from the guest that the device is ready, and then add ports.

Miche

On Sun, Nov 20, 2011 at 9:01 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Thu, 17 Nov 2011 10:57:37 -0800, Miche Baker-Harvey <miche@google.com> wrote:
>> Rusty, Michael, Stephen, et al,
>>
>> Thanks for your comments on these patches.
>>
>> For what I'm trying to do, all three patches are necessary, but maybe
>> I'm going about it the wrong way. Your input would be appreciated.
>> I'm in no way claiming that these patches are "right", just that it's
>> working for me, and that what's in the current pool is not.
>
> We have to *understand* the code.  If we don't, we need to rewrite the
> code so we *do* understand it, or make way for someone who does.
>
> I'm looking at the kvm man page to try to figure out how to have virtio
> console, and it's deeply unclear.  What kvm commandline are you using?
> I'll try to debug it here, and see what I learn about hvc_console.
>
> Cheers,
> Rusty.
>
