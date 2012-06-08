Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933640Ab2FHGJm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 02:09:42 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:59714 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932897Ab2FHGJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 02:09:41 -0400
Date: Fri, 08 Jun 2012 02:09:34 -0400 (EDT)
From: Zhouping Liu <zliu@redhat.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hillf Danton <dhillf@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: AutoNUMA15
Message-ID: <130cc6e8-9077-455a-9e88-3a7b5cde8aff@zmail13.collab.prod.int.phx2.redhat.com>
In-Reply-To: <20120607193747.GH21339@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.66.12.116]
X-Mailer: Zimbra 7.1.2_GA_3268 (ZimbraWebClient - FF3.0 (Linux)/7.1.2_GA_3268)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> > 
> > Thanks! but the Linus tree I tested has contained the patch,
> > also I tested it in autunuma15 with the patch just now, and
> > the panic is still alive, so maybe it's a new issues...
> 
> I guess this 74a5ce20e6eeeb3751340b390e7ac1d1d07bbf55 or this
> 8e7fbcbc22c12414bcc9dfdd683637f58fb32759 may have introduced a
> problem
> with sgp->power being null.

I have tested the kernel after removing the two commit 74a5ce20e6ee & 8e7fbcbc22c1241,
but unluckily, the panic is still alive, so I think it's maybe not
related to the two commit, and I will do more investigating to check
what introduced the panic, please let me know if you need me to test
the special commit.

Thanks,
Zhouping
