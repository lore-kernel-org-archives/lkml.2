Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444Ab2BCSHy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 13:07:54 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:41225 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757428Ab2BCSHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 13:07:19 -0500
MIME-Version: 1.0
In-Reply-To: <4F2AB552.2070909@redhat.com>
References: <4F2AB552.2070909@redhat.com>
Date: Fri, 3 Feb 2012 10:07:18 -0800
Message-ID: <CAG7+5M0s_F93G3dPrRQaFMVv_hPzpd-wYEPApJUDGhh3vJuy-A@mail.gmail.com>
Subject: Re: [RFC] Next gen kvm api
From: Eric Northup <digitaleric@google.com>
To: Avi Kivity <avi@redhat.com>
Cc: KVM list <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 2, 2012 at 8:09 AM, Avi Kivity <avi@redhat.com> wrote:
[...]
>
> Moving to syscalls avoids these problems, but introduces new ones:
>
> - adding new syscalls is generally frowned upon, and kvm will need several
> - syscalls into modules are harder and rarer than into core kernel code
> - will need to add a vcpu pointer to task_struct, and a kvm pointer to
> mm_struct
- Lost a good place to put access control (permissions on /dev/kvm)
for which user-mode processes can use KVM.

How would the ability to use sys_kvm_* be regulated?
