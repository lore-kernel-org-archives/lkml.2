Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab0K3WLJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 17:11:09 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40832 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752475Ab0K3WLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 17:11:06 -0500
MIME-Version: 1.0
In-Reply-To: <1291138954-10310-1-git-send-email-Trond.Myklebust@netapp.com>
References: <1291138954-10310-1-git-send-email-Trond.Myklebust@netapp.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 30 Nov 2010 14:10:44 -0800
Message-ID: <AANLkTimg+4EYfYnKqNsoOpvCcDs+Pb=FB+arb4NvFpx_@mail.gmail.com>
Subject: Re: [PATCH] NFS: Fix a readdirplus bug
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-nfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 9:42 AM, Trond Myklebust
<Trond.Myklebust@netapp.com> wrote:
>
> When comparing filehandles in the helper nfs_same_file(), we should not be
> using 'strncmp()': filehandles are not null terminated strings.

Hmm. Applied, but sadly Nick Bowler <nbowler@elliptictech.com> reports
that it doesn't actually fix his problem, so there is still a serious
regression there.

                Linus
