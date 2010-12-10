Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943Ab0LJK0K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 05:26:10 -0500
Received: from smtpeu1.atmel.com ([195.65.72.27]:50890 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753524Ab0LJK0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 05:26:08 -0500
Subject: Re: [PATCH v2] avr32: Fix build failure conflicting types for
 'sys_execve'
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: Peter Huewe <peterhuewe@gmx.de>
Cc: "David S. Miller" <davem@davemloft.net>,
        David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        stable@kernel.org
In-Reply-To: <1291929328-30551-1-git-send-email-peterhuewe@gmx.de>
References: <20101209182132.GB24175@kroah.com>
	 <1291929328-30551-1-git-send-email-peterhuewe@gmx.de>
Content-Type: text/plain; charset="UTF-8"
Organization: Atmel Corporation
Date: Fri, 10 Dec 2010 11:25:41 +0100
Message-ID: <1291976741.18008.37.camel@hcegtvedt>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Dec 2010 10:25:43.0772 (UTC) FILETIME=[99F339C0:01CB9854]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-09 at 22:15 +0100, Peter Huewe wrote: 
> This patch fixes a build failure[1] for the avr32 architecture which seems
> to be introduced by commit d7627467b7a8
> "Make do_execve() take a const filename pointer"
> 
> The commit changes the definition in arch/avr32/kernel/process.c but
> forgot to change it here.
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> Cc: stable <stable@kernel.org>

Nack, I've piped up a patch in
http://git.kernel.org/?p=linux/kernel/git/egtvedt/avr32-2.6.git;a=shortlog;h=refs/heads/next that does this and more. The syscalls.h header file needs a bit more cleanup.

I'll also notify stable to get it backported. Do you have an idea how
far back it should go?

-- 
Hans-Christian Egtvedt

