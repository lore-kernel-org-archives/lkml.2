Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405Ab0JUJRz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 05:17:55 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39509 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327Ab0JUJRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 05:17:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=JnKakccC0vbqmQOfs1hJz4dYrcqGFyS7EXZsD4m0kI4x6hmCXVphO+LWXrHrYW2L+8
         aLO+rUB1WSF8jflTbteg7nCYBADJ10fB3wCdsrF375RfXCSqCwt6anUIpsGvu1MzI0Hm
         GCjziQqMeqNS2385gEWCX1vP9eKJV4gGqPjcs=
MIME-Version: 1.0
Date: Thu, 21 Oct 2010 11:17:53 +0200
Message-ID: <AANLkTin4A61K9uW1Cns3rr3eDkWQ+KCBP8jt4M4tFQHP@mail.gmail.com>
Subject: Re: Re: [RFC/RFT PATCH] sched: automated per tty task groups
From: Marco <mpiazza@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, i'm a little confused about tty grouping.
The benefit in terms of latency is only due to the grouping of task
under the appropriate cgroup hierarchy?

Can this issue be solved by userspace daemon (think of libpam-systemd,
libpam-cgroup)? Perhaps tty grouping in kernel space is more
efficient.

I'm missing something?

Marco
