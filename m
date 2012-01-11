Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461Ab2AKKkw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 05:40:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44866 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040Ab2AKKkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 05:40:51 -0500
Date: Wed, 11 Jan 2012 02:45:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Daniel Lezcano <daniel.lezcano@free.fr>,
        containers@lists.linux-foundation.org, oleg@redhat.com,
        linux-kernel@vger.kernel.org, mtk.manpages@gmail.com
Subject: Re: [PATCH 1/1][V5] Add reboot_pid_ns to handle the reboot syscall
Message-Id: <20120111024530.7b3607e7.akpm@linux-foundation.org>
In-Reply-To: <20120111102346.GB8504@peqn>
References: <1325754410-32600-1-git-send-email-daniel.lezcano@free.fr>
	<1325754410-32600-2-git-send-email-daniel.lezcano@free.fr>
	<20120105192954.GA16083@sergelap>
	<20120111102346.GB8504@peqn>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jan 2012 11:23:46 +0100 Serge Hallyn <serge.hallyn@canonical.com> wrote:

> > 
> > The testcase in [PATCH 0/1] passed for me, and reboot from init_pid_ns
> > works as usual.
> > 
> > Tested-by: Serge Hallyn <serge.hallyn@canonical.com>
> 
> Hi Andrew,
> 
> Are you considering taking this patch into -mm?

I have it queued up to look at.  I'll do that I've merged the current
lot into rc1 - if I were to merge new stuff before then I'd only
confuse myself ;)
