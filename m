Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935272Ab1ETFHD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 01:07:03 -0400
Received: from gate.crashing.org ([63.228.1.57]:48832 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935184Ab1ETFHC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 01:07:02 -0400
Subject: Re: PM: Remove sysdev suspend, resume and shutdown operations
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: git-commits-head@vger.kernel.org
In-Reply-To: <201105200000.p4K00YYZ026097@hera.kernel.org>
References: <201105200000.p4K00YYZ026097@hera.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 May 2011 15:06:57 +1000
Message-ID: <1305868017.7481.144.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-20 at 00:00 +0000, Linux Kernel Mailing List wrote:
> Gitweb:     http://git.kernel.org/linus/2e711c04dbbf7a7732a3f7073b1fc285d12b369d
> Commit:     2e711c04dbbf7a7732a3f7073b1fc285d12b369d
> Parent:     f5a592f7d74e38c5007876c731e6bf5580072e63
> Author:     Rafael J. Wysocki <rjw@sisk.pl>
> AuthorDate: Tue Apr 26 19:15:07 2011 +0200
> Committer:  Rafael J. Wysocki <rjw@sisk.pl>
> CommitDate: Wed May 11 21:37:15 2011 +0200
> 
>     PM: Remove sysdev suspend, resume and shutdown operations
>     
>     Since suspend, resume and shutdown operations in struct sysdev_class
>     and struct sysdev_driver are not used any more, remove them.  Also
>     drop sysdev_suspend(), sysdev_resume() and sysdev_shutdown() used
>     for executing those operations and modify all of their users
>     accordingly.  This reduces kernel code size quite a bit and reduces
>     its complexity.

Your grep is broken ? :-)

You forgot drivers/macintosh/via-pmu.c ... I'll stick a fix in powerpc
before I send to Linus later today.

Cheers,
Ben.

