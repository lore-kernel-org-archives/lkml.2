Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690Ab0F2WxL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 18:53:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57078 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750733Ab0F2WxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 18:53:08 -0400
Date: Tue, 29 Jun 2010 15:51:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       djwong@us.ibm.com, muli@il.ibm.com, cschultz@linux.vnet.ibm.com,
       stable@kernel.org, tglx@linutronix.de, mingo@elte.hu
Cc: "tip-bot for Darrick J. Wong" <djwong@us.ibm.com>,
       linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, mingo@redhat.com, muli@il.ibm.com,
       cschultz@linux.vnet.ibm.com, stable@kernel.org, tglx@linutronix.de,
       mingo@elte.hu
Subject: Re: [tip:x86/urgent] x86, Calgary: Increase max PHB number
Message-Id: <20100629155151.7caaff4b.akpm@linux-foundation.org>
In-Reply-To: <tip-499a00e92dd9a75395081f595e681629eb1eebad@git.kernel.org>
References: <20100624212647.GI15515@tux1.beaverton.ibm.com>
	<tip-499a00e92dd9a75395081f595e681629eb1eebad@git.kernel.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jun 2010 15:29:50 GMT
"tip-bot for Darrick J. Wong" <djwong@us.ibm.com> wrote:

> Commit-ID:  499a00e92dd9a75395081f595e681629eb1eebad
> Gitweb:     http://git.kernel.org/tip/499a00e92dd9a75395081f595e681629eb1eebad
> Author:     Darrick J. Wong <djwong@us.ibm.com>
> AuthorDate: Thu, 24 Jun 2010 14:26:47 -0700
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Fri, 25 Jun 2010 16:14:58 +0200
> 
> x86, Calgary: Increase max PHB number

arch/x86/kernel/pci-calgary_64.c: In function 'calgary_init_one':
arch/x86/kernel/pci-calgary_64.c:1059: warning: comparison is always false due to limited range of data type

from

        BUG_ON(dev->bus->number >= MAX_PHB_BUS_NUM);

with

http://userweb.kernel.org/~akpm/stuff/config-akpm2.txt
