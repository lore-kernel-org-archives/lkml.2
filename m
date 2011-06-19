Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695Ab1FSRGq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 13:06:46 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:56974 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947Ab1FSRGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 13:06:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonas Bonn <jonas@southpole.se>
Subject: Re: OpenRISC Architecture: Request for review
Date: Sun, 19 Jun 2011 19:06:23 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
References: <1308483825-6023-1-git-send-email-jonas@southpole.se>
In-Reply-To: <1308483825-6023-1-git-send-email-jonas@southpole.se>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106191906.23874.arnd@arndb.de>
X-Provags-ID: V02:K0:UeHhgW6N+2yh1NNtwl0EilrE7pYoqN6bJT0764ZvIXC
 1Z6K0kuBozU33f2rETSaGd7U5ll/BNKKAYnj+8D/0sWxd5nFc3
 NOesP3l3fNmIYhudLsF1AVsKHC1cMrYANN1JgD2Lih+Hsq4QrZ
 u20wnwGtj9928i1XC3Znh0Ig8s0kV2viYIJWpXnvetJ7umgQ5f
 6JCcmZpW1Lpd1NNsyutcA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 19 June 2011 13:43:26 Jonas Bonn wrote:
> 
> This is a port of Linux to the OpenRISC 1000 architecture.
> 
> The OpenRISC architecture was conceived with the idea of creating a CPU
> with an open specification and freely licensed implementations thereof.
> The OR1200 implementation of the OpenRISC 1000 architecture is LGPL licensed,
> runs on FPGA's from a broad number of vendors, and is currently being
> used in a number of successful industrial projects.

Hi Jonas,

Thanks for your submission, it looks very nice and is well split up into
readable patches. I have no doubt that you will be able to get this included
in Linux-3.1 given the high quality. I'll go through the individual patches
and comment on anything that sticks out. Please resubmit once you have
addressed all of the comments from me and other people, and take
linux-arch@vger.kernel.org on Cc for the second round, because otherwise
some people may miss the patches in the daily flood.

> There's a short TODO.openrisc file, as well.  Some of the items listed
> there could potentially be done before any pull request for the architecture
> is sent.

How about including the TODO file here?

> There are also fair number of places where we still have old test code
> laying about inside #ifdefs and comments.  The intention is to get all that
> cleaned up before the final pull request, but I didn't want to allow that
> to delay beginning the review process any further.

I agree that this is important to clean it all up, but it's good that you
posted the current version.

I would also suggest that you let Stephen Rothwell add your git tree to
the linux-next sources, provided that it merges cleanly with the upstream
kernel.

	Arnd
