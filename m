Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751Ab0JUJIG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 05:08:06 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:54001 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376Ab0JUJIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 05:08:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jan Harkes <jaharkes@cs.cmu.edu>
Subject: Re: [RFC][PATCH 0/3] Coda: remove BKL
Date: Thu, 21 Oct 2010 11:08:41 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1287606184-26889-1-git-send-email-jaharkes@cs.cmu.edu>
In-Reply-To: <1287606184-26889-1-git-send-email-jaharkes@cs.cmu.edu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201010211108.41320.arnd@arndb.de>
X-Provags-ID: V02:K0:pDxmcIOLywiHWNDR5if+M8xrQ4SByq0oSSuqC51uNrk
 rCRsyPjPFr7qXPhqIIpuiDxVdrZFBS5mfLh4o5t3MqX1Vntdpk
 ZPP8qWmz/urQreaxtmiPiSebtXpRoN/cYW2lAK9pUw9kuLrBpX
 qQRdaTo4JCztf1lJ4BA23DPOr/LMfB/5+/TJAaBQQAGawuHJEr
 cxMJ8qnkj1EZTDknKBUcQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 October 2010, Jan Harkes wrote:
> The following three patches remove the big kernel lock from the Coda
> file system kernel module. We initially add a spinlock to protect the
> Coda-specific inode data. After this we can push the BKL all the way
> down to where the requests are queued for the userspace Coda cache
> manager process and finally we replace the remaining BKL uses with a
> mutex that protects the upcall queues.

Very nice!

Are you pushing this to Linus or should I take care of it along with
the other file systems?

This patch is larger than most of the others, but I can add it to
my bkl/vfs tree if you like.

	Arnd
