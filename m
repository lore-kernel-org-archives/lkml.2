Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606Ab1JTKjS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 06:39:18 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45862 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755635Ab1JTKjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 06:39:17 -0400
MIME-Version: 1.0
In-Reply-To: <201110201225.59627.wpk@culm.net>
References: <1317382585-12172-1-git-send-email-wpk@culm.net>
 <CALdu-PDCxS49_GBBUQUskotKb_46O31YM8Tx+cniGfBa5X169g@mail.gmail.com> <201110201225.59627.wpk@culm.net>
From: Paul Menage <paul@paulmenage.org>
Date: Thu, 20 Oct 2011 03:38:57 -0700
X-Google-Sender-Auth: IW2YKvAYoheTP04czGwjv1ig1fw
Message-ID: <CALdu-PD59bHDBP5Tbni9y9FYvWxjvbs0Orizv8RSSZmsbcJumg@mail.gmail.com>
Subject: Re: [PATCH 0/6] cgroup: add isolation_root flag, poor man's
 namespaces for cgroups
To: Witold Krecicki <wpk@culm.net>
Cc: Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Matt Helsley <matthltc@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 20, 2011 at 3:25 AM, Witold Krecicki <wpk@culm.net> wrote:
> I tried to make it as simple as possible - and this approach (looking at patch
> length) seemed to be the simplest (we really don't care about 'other' cgroups
> that might appear).

Right, this is a nicely simple approach that gets rid of some nasty
incompatibilities between containers and cgroups, so it's a great
first step. But it still limits what containers can do with cgroups
(in terms of combining subsystems in hierarchies), hence the idea that
we plan what we might want to do later, and at least make the API
something that could also accommodate the possible future. (In the
same sense that the cgroups mount API has always supported the
possibility of mounting a subsystem on multiple hierarchies at once,
even if the patches to implement it didn't appear for another year or
so and are still languishing and bit-rotting).

> Other approaches would probably require major rewrites of cgroups code.

Not major rewrites, really, but definitely some fiddly replumbing.

Paul
