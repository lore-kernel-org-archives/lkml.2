Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693Ab1HVGSr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 02:18:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56337 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753313Ab1HVGSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 02:18:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: manual merge of the pm tree with the s390 tree
Date: Mon, 22 Aug 2011 08:20:29 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
References: <20110822123705.d947c6a2548082168df9c86a@canb.auug.org.au>
In-Reply-To: <20110822123705.d947c6a2548082168df9c86a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108220820.29739.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, August 22, 2011, Stephen Rothwell wrote:
> Hi Rafael,
> 
> Today's linux-next merge of the pm tree got a conflict in
> arch/s390/include/asm/thread_info.h between commit 5f67c275efe7 ("[S390]
> fix _TIF_SINGLE_STEP definition") from the s390 tree and commit
> c9ff4d7b50c4 ("freezer: remove now unused TIF_FREEZE") from the pm tree.
> 
> I fixed it up (see below)

Thanks!

> and can carry the fix as necessary.

Please do that.

Rafael
