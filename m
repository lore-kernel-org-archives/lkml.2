Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292Ab2JWShM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 14:37:12 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33707 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756708Ab2JWShK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 14:37:10 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1210231320390.2689@kaball.uk.xensource.com>
References: <1350593430-24470-1-git-send-email-yinghai@kernel.org>
	<1350593430-24470-10-git-send-email-yinghai@kernel.org>
	<alpine.DEB.2.02.1210191714330.2689@kaball.uk.xensource.com>
	<CAE9FiQX-JBHvjqLyjutKfBUp2DQKEwVMGEkj7Wi6yijAERhP6w@mail.gmail.com>
	<alpine.DEB.2.02.1210221405010.2689@kaball.uk.xensource.com>
	<CAE9FiQViaompYixDoOb_XPA4Npwb0RyYu2czfpAGMGQbVSCB=A@mail.gmail.com>
	<alpine.DEB.2.02.1210231320390.2689@kaball.uk.xensource.com>
Date: Tue, 23 Oct 2012 11:37:08 -0700
X-Google-Sender-Auth: FEOj7cxrjEZ6gmZS8oGHQmWirNo
Message-ID: <CAE9FiQXvN5LMQCFwU6_RWjmS8fbL=NMbJonC3dCHe-+=uy9daw@mail.gmail.com>
Subject: Re: [PATCH 06/19] x86, mm: setup page table in top-down
From: Yinghai Lu <yinghai@kernel.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 5:22 AM, Stefano Stabellini
<stefano.stabellini@eu.citrix.com> wrote:
> On Mon, 22 Oct 2012, Yinghai Lu wrote:
>> Can you test domU 32bit too?
>> I did not test that, and looks like Jacob only test 64 bit domU too.
>
> Sure. It works fine.

great.

Do you know any simple way to test xen domU after pxe booting xen/dom0 via pxe?

>From kvm, it is simple with pxe:
1. build kernel and iso at the same time., initrd is converted from
opensuse rescue initramfs.
2. copy kernel and iso into boot server
3. network boot the kernel
4. mount nfs dir so could access iso, and qemu-kvm.
5. qemu-kvm to load the iso.
