Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464Ab0HWXgA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 19:36:00 -0400
Received: from smtp-out.google.com ([74.125.121.35]:24689 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab0HWXf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 19:35:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Eo0CnOYLuf1cdeywjJ/5ZNEbsS6v3EbLuJ76zmSsJ+TyMBWMV1DXRPnTg+ByVLWACz
         pvTfPegjBxwKHYo71b/A==
MIME-Version: 1.0
In-Reply-To: <20100811054711.GB8743@ghc17.ghc.andrew.cmu.edu>
References: <20100730235649.GA22644@ghc17.ghc.andrew.cmu.edu>
	<20100811054604.GA8743@ghc17.ghc.andrew.cmu.edu>
	<20100811054711.GB8743@ghc17.ghc.andrew.cmu.edu>
Date: Mon, 23 Aug 2010 16:35:55 -0700
Message-ID: <AANLkTi=e-kwUzfb2Mv8JmwKm_AxyB=ZeTVb+K0dBU4eu@mail.gmail.com>
Subject: Re: [PATCH v5 1/3] cgroups: read-write lock CLONE_THREAD forking per threadgroup
From: Paul Menage <menage@google.com>
To: Ben Blum <bblum@andrew.cmu.edu>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        akpm@linux-foundation.org, ebiederm@xmission.com, lizf@cn.fujitsu.com,
        matthltc@us.ibm.com, oleg@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 10, 2010 at 10:47 PM, Ben Blum <bblum@andrew.cmu.edu> wrote:
>
>
> Adds functionality to read/write lock CLONE_THREAD fork()ing per-threadgroup
>
> From: Ben Blum <bblum@andrew.cmu.edu>
>
> This patch adds an rwsem that lives in a threadgroup's signal_struct that's
> taken for reading in the fork path, under CONFIG_CGROUPS. If another part of
> the kernel later wants to use such a locking mechanism, the CONFIG_CGROUPS
> ifdefs should be changed to a higher-up flag that CGROUPS and the other system
> would both depend on.
>
> This is a pre-patch for cgroup-procs-write.patch.
>
> Signed-off-by: Ben Blum <bblum@andrew.cmu.edu>

Acked-by: Paul Menage <menage@google.com>

Paul
