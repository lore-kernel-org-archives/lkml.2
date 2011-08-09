Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622Ab1HIIbq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 04:31:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:45513 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192Ab1HIIbp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 04:31:45 -0400
Subject: Re: [PATCH][RT] fix KM_TYPE_NR undeclared in sched.h on 32 bit x86
From: Peter Zijlstra <peterz@infradead.org>
To: Darren Hart <dvhart@linux.intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        "Ashfield, Bruce" <Bruce.Ashfield@windriver.com>
Date: Tue, 09 Aug 2011 10:31:29 +0200
In-Reply-To: <4E40B2BF.3030608@linux.intel.com>
References: <4E40B2BF.3030608@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1312878690.22367.48.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-08 at 21:08 -0700, Darren Hart wrote:
> Patch peter_zijlstra-re-_3_0-rt4.patch causes 32 bit compilations to fail with:
> sched.h:1592:17: error: ‘KM_TYPE_NR’ undeclared here (not in a function)
> 
> Including asm/kmap_types in sched.h resolves the issue.
> 
> Signed-off-by: Darren Hart <dvhart@linux.intel.com>

Yep indeed, I wonder why my i386-defconfig build.. header deps magic or
so.

I've updated the patch in question, thanks!
