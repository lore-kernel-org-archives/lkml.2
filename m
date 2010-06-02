Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933253Ab0FBWDz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 18:03:55 -0400
Received: from smtp-out.google.com ([216.239.44.51]:59738 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933178Ab0FBWDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 18:03:53 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=qXkBHBp3dPCyYBWNwVTWpzIIiWa+mbcCyFgKhD/uEynNuu0wF+npldldIqlRh2lF9
	KdmilxQ4EXPES7iJVPreA==
MIME-Version: 1.0
In-Reply-To: <20100602213832.GB31949@redhat.com>
References: <20100530013303.GC762@ghc01.ghc.andrew.cmu.edu>
	<20100531175242.GA14691@redhat.com>
	<20100531180446.GA16249@redhat.com>
	<AANLkTimcrX0TjzDMNJdubR92pAO4IPATbVpyvvVt0qIV@mail.gmail.com>
	<20100602140659.GA5324@redhat.com>
	<AANLkTin-T6ij3xf0ceGoCamwcoayxyf0GdAKY6yXDMVl@mail.gmail.com>
	<20100602202048.GB28663@redhat.com>
	<AANLkTimrJFiidM8BlUNvmzfapUAv8369R9PYnTscasEf@mail.gmail.com>
	<20100602205855.GA30039@redhat.com>
	<AANLkTimfHlapl7mbRyAazWW5q5Wzs23n6i9wIhVtSv6r@mail.gmail.com>
	<20100602213832.GB31949@redhat.com>
Date: Wed, 2 Jun 2010 15:03:49 -0700
Message-ID: <AANLkTimsusetA9B95-LvKsDdAB_PegYH7Zljyi4Doe_q@mail.gmail.com>
Subject: Re: [RFC] [PATCH 2/2] cgroups: make procs file writable
From: Paul Menage <menage@google.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ben Blum <bblum@andrew.cmu.edu>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, akpm@linux-foundation.org,
       ebiederm@xmission.com, lizf@cn.fujitsu.com, matthltc@us.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 2, 2010 at 2:38 PM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> cgroup_attach_task() does, and this time PF_EXITING is understandable.
>

Oh, OK, I was talking about the one in cgroup_attach_task(), which is
called by attach_task_by_pid(), and assumed that you were referring to
the same one. I'd forgotten about the pre-check in
attach_task_by_pid(). Yes, that one could probably be removed without
affecting any final outcomes.

Paul
