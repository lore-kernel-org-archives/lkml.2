Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751155Ab1KMGAT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 01:00:19 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61842 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752Ab1KMGAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 01:00:17 -0500
MIME-Version: 1.0
In-Reply-To: <20111110040644.GA5434@phenom.dumpdata.com>
References: <1320786914-10541-1-git-send-email-konrad.wilk@oracle.com>
	<1320786914-10541-2-git-send-email-konrad.wilk@oracle.com>
	<20111110040644.GA5434@phenom.dumpdata.com>
Date: Sun, 13 Nov 2011 01:00:15 -0500
X-Google-Sender-Auth: yqpJBOE1mnaBVytpzfbzrhCAN4o
Message-ID: <CAJvTdKnSLD8q3QqcFVY7u-eyhTnN=2rQ3rTmd1qeJ7nGz4y5Bg@mail.gmail.com>
Subject: Re: [Xen-devel] [PATCH 1/3] cpuidle: If disable_cpuidle() is called,
 set pm_idle to default_idle.
From: Len Brown <lenb@kernel.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, len.brown@intel.com,
        tglx@linutronix.de, jeremy@goop.org, hpa@zytor.com, bp@alien8.de,
        tj@kernel.org, trenn@suse.de, stable@kernel.org, mingo@redhat.com,
        xen-devel@lists.xensource.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> And just found that there is a BZ for this as well:
> https://bugzilla.redhat.com/show_bug.cgi?id=739499
>
> And this patch fixes the Linux kernel to boot under Amazon EC2.

doesn't matter.

Working around an Amazon EC2 bug in a newly compiled upstream kernel
isn't going to help with any of the kernels that don't include that workaround.

Amazon EC2 should not advertise MWAIT support that it does not have,
and all kernels should run on it w/o any workaround.

Len Brown, Intel Open Source Technology Center
