Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574Ab1LXF1G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Dec 2011 00:27:06 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:56187 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab1LXF1E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Dec 2011 00:27:04 -0500
MIME-Version: 1.0
In-Reply-To: <CAO_0yfMFQT4o=pwgmt6AME7kGJ9EAzWC2-gaf-oa7D7Gk1YHRw@mail.gmail.com>
References: <CAO_0yfMFQT4o=pwgmt6AME7kGJ9EAzWC2-gaf-oa7D7Gk1YHRw@mail.gmail.com>
From: Yang Bai <hamo.by@gmail.com>
Date: Sat, 24 Dec 2011 13:26:43 +0800
Message-ID: <CAO_0yfMbUD_YTrnFADLULeMeDW12ANW+DAA7ZLHM8dR3mvd7Tg@mail.gmail.com>
Subject: Re: [PATCH] KVM: fix undeclared MAY_{READ,WRITE,ACCESS}
To: avi@redhat.com, mtosatti@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 24, 2011 at 1:22 PM, Yang Bai <hamo.by@gmail.com> wrote:
> commit 08a95a511af91a2a6c42f2a8f13b99402a39e84b checksdevice
> assignment permission but forgot to include thedefinition of
> MAY_{READ,WRITE,ACCESS} in linux/fs.hInclude it and this fix the build
> error here:http://buildbot.b1-systems.de/kvm/builders/i386/builds/401
> Signed-off-by: Yang Bai <hamo.by@gmail.com>--- virt/kvm/assigned-dev.c
> |    1 + 1 files changed, 1 insertions(+), 0 deletions(-)
> diff --git a/virt/kvm/assigned-dev.c b/virt/kvm/assigned-dev.cindex
> da9690e..1d9dad0 100644--- a/virt/kvm/assigned-dev.c+++
> b/virt/kvm/assigned-dev.c@@ -18,6 +18,7 @@ #include
> <linux/interrupt.h> #include <linux/slab.h> #include
> <linux/namei.h>+#include <linux/fs.h> #include "irq.h"  static struct
> kvm_assigned_dev_kernel *kvm_find_assigned_dev(struct list_head
> *head,-- 1.7.7.3
>
Format wrong. Will resend it.
