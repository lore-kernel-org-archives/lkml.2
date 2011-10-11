Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751731Ab1JKXQF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 19:16:05 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58631 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab1JKXQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 19:16:03 -0400
Date: Tue, 11 Oct 2011 16:16:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel@vger.kernel.org, lennart@poettering.net, harald@redhat.com,
        david@fubar.dk, greg@kroah.com,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: A =?UTF-8?Q?Plumber=E2=80=99s?= Wish List for Linux
Message-Id: <20111011161600.6145aa6b.akpm@linux-foundation.org>
In-Reply-To: <1317943022.1095.25.camel@mop>
References: <1317943022.1095.25.camel@mop>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Useful email, thanks.

On Fri, 07 Oct 2011 01:17:02 +0200
Kay Sievers <kay.sievers@vrfy.org> wrote:

> We___d like to share our current wish list of plumbing layer features we

gargh.  gmail?

>
> ...
>
> * fork throttling mechanism as basic cgroup functionality that is
> available in all hierarchies independent of the controllers used:
> This is important to implement race-free killing of all members of a
> cgroup, so that cgroup member processes cannot fork faster then a cgroup
> supervisor process could kill them. This needs to be recursive, so that
> not only a cgroup but all its subgroups are covered as well.

Frederic Weisbecker's "cgroups: add a task counter subsystem" should
address this.  Does it meet these requirments?  Have you tested it?

>
> ...
>
> * Add a timerslack cgroup controller, to allow increasing the timer
> slack of user session cgroups when the machine is idle.

Kirill Shutemov has just posted "cgroups: introduce timer slack
controller".  Again, is that sufficient?  Have you reviewed and tested
it?

>
> ...
>
