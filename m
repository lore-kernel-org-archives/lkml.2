Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275Ab0HMXdK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 19:33:10 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:51437 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755444Ab0HMXdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 19:33:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=m2srGYyhfd2te4lfQuoe84UJ7rHSnt8CLV3xzU9zTc5bVZrWHkXNUGctiKHwIi6TXZybCa/EV/MbKj0RtFXQIB9eKckhdBOq8GInjs6hnl7Gp2Nb/zYo1n0XpqOkIA97;
Date: Fri, 13 Aug 2010 16:33:06 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, John Kacur <jkacur@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Tejun Heo <tj@kernel.org>,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 4/8] proc/pci: kill BKL
Message-ID: <20100813163306.08ec5715@virtuousgeek.org>
In-Reply-To: <1278194552-24943-5-git-send-email-arnd@arndb.de>
References: <1278194552-24943-1-git-send-email-arnd@arndb.de>
	<1278194552-24943-5-git-send-email-arnd@arndb.de>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  4 Jul 2010 00:02:28 +0200
Arnd Bergmann <arnd@arndb.de> wrote:

> All operations in the pci procfs ioctl functions are
> atomic, so no lock is needed here.
> 
> Also add a compat_ioctl method, since all the commands
> are compatible in 32 bit mode.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: linux-pci@vger.kernel.org
> ---

Oops, I had assumed this was going through some master 'kill the bkl'
tree.  Applied to my linux-next branch now though, sorry for the delay.

-- 
Jesse Barnes, Intel Open Source Technology Center
