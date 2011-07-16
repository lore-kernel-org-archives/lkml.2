Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668Ab1GPTPA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 15:15:00 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:59803 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757Ab1GPTO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 15:14:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: Tree for July 16
Date: Sat, 16 Jul 2011 21:14:09 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <20110717000815.c83755be9598d34ac8431908@canb.auug.org.au>
In-Reply-To: <20110717000815.c83755be9598d34ac8431908@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201107162114.09441.arnd@arndb.de>
X-Provags-ID: V02:K0:XRtGe4eQVZnnXYDtFzoELag3A5lvCY/2+a1hT28OXq1
 amZwktKXmfFGYMHSE2Ebu9Yf5EPkOuItnSmGRlS4bWHC/aR7He
 oZ+Tyogo116mDYYeSRXTP+ZiZ0XcFp/2jUcpSfIItVyGleDSCS
 VXp/QFLOEnDxWloN1TBRoSRfwak3K0HXK8Ad6erPpuOl92kLoF
 o3O2Ys9AT8ixOEushNJPA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 16 July 2011 16:08:15 Stephen Rothwell wrote:
> The pci-current tree lost its build failure.
> 
> The arm-soc tree has complex conflicts against the arm tree so I have
> dropped it for today.

Sorry about that. I was notified of this before, but didn't get to cleanly
redo the tree yet. The problem was that I first tried to merge the for-next
branch of the ARM tree into the arm-soc master branch, but I couldn't find\
a way to deal with the arm-soc tree getting rebased.

I now plan to start a new arm-soc/for-next branch that will have the same
contents but also gets rebased. I'll let you know when I get there.

	Arnd
