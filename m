Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758140Ab0FOSH6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 14:07:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45465 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754665Ab0FOSH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 14:07:57 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <AANLkTikxOwYQYSzNjEqRduTQvoUandnAsZzm5Auzgnaz@mail.gmail.com>
References: <AANLkTikxOwYQYSzNjEqRduTQvoUandnAsZzm5Auzgnaz@mail.gmail.com> <E1OMQ88-0002a1-Gb@closure.thunk.org> <AANLkTilqc0jpwnIwe3OIQvB9avaXXzrBK4Hz0huESygy@mail.gmail.com> <20100613194949.GC8055@thunk.org> <AANLkTilQLk7ofSJBm9KIa2g1KQ35GC1D1vOZlPrv1VRv@mail.gmail.com> <20100614184244.GA11480@elliptictech.com> <20100614214646.GF6666@thunk.org> 
To: Andy Whitcroft <apw@canonical.com>
Cc: dhowells@redhat.com, tytso@mit.edu, Dave Airlie <airlied@gmail.com>,
       Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Why is kslowd accumulating so much CPU time?
Date: Tue, 15 Jun 2010 19:07:48 +0100
Message-ID: <18402.1276625268@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Whitcroft <apw@canonical.com> wrote:

> I am seeing crunchy cursor behavior on boot on Ubuntu Lucid user space
> with the 2.6.35-rc3 kernel as well.  It pretty much always does that
> on boot, and often later as well.  Right now I have four of these
> chaps each consuming 9% of a CPU.  Though they definatly come and go.
> Very odd:
> 
>   938 root      15  -5     0    0    0 S    9  0.0   1:00.90 kslowd001
>  1048 root      15  -5     0    0    0 S    9  0.0   1:01.12 kslowd002
>   937 root      15  -5     0    0    0 S    8  0.0   1:00.92 kslowd000
>  1544 root      15  -5     0    0    0 D    8  0.0   1:00.55 kslowd003

Can you see what they're doing?

	watch -n0 cat /sys/kernel/debug/slow_work/runqueue

David
