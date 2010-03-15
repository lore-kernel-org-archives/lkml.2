Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965707Ab0COS7o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 14:59:44 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35846
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965680Ab0COS7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 14:59:43 -0400
Date: Mon, 15 Mar 2010 12:00:04 -0700 (PDT)
Message-Id: <20100315.120004.209998642.davem@davemloft.net>
To: drepper@redhat.com
Cc: hpa@zytor.com, ralf@linux-mips.org, benh@kernel.crashing.org,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel@teksavvy.com, torvalds@linux-foundation.org,
       munroesj@linux.vnet.ibm.com
Subject: Re: 64-syscall args on 32-bit vs syscall()
From: David Miller <davem@davemloft.net>
In-Reply-To: <4B9E59B7.6060405@redhat.com>
References: <20100315134449.GB1653@linux-mips.org>
	<4B9E4EB1.9010800@zytor.com>
	<4B9E59B7.6060405@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ulrich Drepper <drepper@redhat.com>
Date: Mon, 15 Mar 2010 09:00:55 -0700

> On 03/15/2010 08:13 AM, H. Peter Anvin wrote:
>> One option would be to do a libkernel.so,
> 
> No need.  Put it in the vdso.  And name it something other than syscall.
>  The syscall() API is fixed, you cannot change it.
> 
> All this only if it makes sense for ALL archs.  If it cannot work for
> just one arch then it's not worth it at all.

There are many archs that still lack VDSO.
