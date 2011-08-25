Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086Ab1HYO0e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 10:26:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37566 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182Ab1HYO03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 10:26:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: manual merge of the pm tree with the arm tree
Date: Thu, 25 Aug 2011 16:28:18 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jon Medhurst <tixy@yxit.co.uk>, Russell King <rmk@arm.linux.org.uk>
References: <20110825133014.4ca16d7b383f7582c7a52d46@canb.auug.org.au>
In-Reply-To: <20110825133014.4ca16d7b383f7582c7a52d46@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108251628.18531.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 25, 2011, Stephen Rothwell wrote:
> Hi Rafael,
> 
> Today's linux-next merge of the pm tree got a conflict in
> arch/arm/mach-shmobile/board-ap4evb.c between commit 9b742024026c ("ARM:
> mach-shmobile: Setup consistent dma size at boot time") from the arm tree
> and commit 2f82df20d71c ("PM: Move clock-related definitions and headers
> to separate file") from the pm tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

Thanks a lot!
