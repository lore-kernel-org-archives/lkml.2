Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806Ab0HXSJF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 14:09:05 -0400
Received: from smtp-out.google.com ([216.239.44.51]:45460 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755313Ab0HXSJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 14:09:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=C5LD7XCv17B5eVqbNzCR9MsUSvIC963EiwXm3ZLz5SKAgq+64XvOu3S+PS5tYgdpDa
         EKp5vsk+vfT3vmMIS7Xg==
MIME-Version: 1.0
In-Reply-To: <20100811054851.GD8743@ghc17.ghc.andrew.cmu.edu>
References: <20100730235649.GA22644@ghc17.ghc.andrew.cmu.edu>
	<20100811054604.GA8743@ghc17.ghc.andrew.cmu.edu>
	<20100811054851.GD8743@ghc17.ghc.andrew.cmu.edu>
Date: Tue, 24 Aug 2010 11:08:58 -0700
Message-ID: <AANLkTimRM8rDe+u7fTy853RK=1mnLJMK57Tci2OLPR7L@mail.gmail.com>
Subject: Re: [PATCH v5 3/3] cgroups: make procs file writable
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

On Tue, Aug 10, 2010 at 10:48 PM, Ben Blum <bblum@andrew.cmu.edu> wrote:
>
>
> Makes procs file writable to move all threads by tgid at once
>
> From: Ben Blum <bblum@andrew.cmu.edu>
>
> This patch adds functionality that enables users to move all threads in a
> threadgroup at once to a cgroup by writing the tgid to the 'cgroup.procs'
> file. This current implementation makes use of a per-threadgroup rwsem that's
> taken for reading in the fork() path to prevent newly forking threads within
> the threadgroup from "escaping" while the move is in progress.
>
> Signed-off-by: Ben Blum <bblum@andrew.cmu.edu>

Reviewed-by: Paul Menage <menage@google.com>
