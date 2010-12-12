Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210Ab0LLOI1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 09:08:27 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:56469 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752557Ab0LLOIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 09:08:25 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18Pw20PYkwPT+tSjd7xpM2D45YvrgDWREfs0fThuz
	SArlXbAb3Uhp05
Subject: Re: [RFC/RFT PATCH] sched: automated per tty task groups
From: Mike Galbraith <efault@gmx.de>
To: Tom Gundersen <teg@jklm.no>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTimdBb-j=8qrkO+dbH6ATE_64vODCGbfqO=H5YGZ@mail.gmail.com>
References: <AANLkTimdBb-j=8qrkO+dbH6ATE_64vODCGbfqO=H5YGZ@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 12 Dec 2010 15:08:21 +0100
Message-Id: <1292162901.7466.2.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-12-12 at 14:49 +0100, Tom Gundersen wrote:
> Hi Mike,
> 
> I have a question about your patch:
> 
> If I understand sched-rt-group.txt correctly, a non-root user will not
> be able to run rt tasks if it is in a cgroup that has not been
> explicitly given non-zero bandwidth. I could not see from your patch
> where the bandwidth is assigned. Care to explain how it works?

It doesn't touch RT tasks.

	-Mike

