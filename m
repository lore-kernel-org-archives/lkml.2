Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758039Ab0LBTx5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 14:53:57 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:23927 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757929Ab0LBTx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 14:53:56 -0500
Date: Thu, 2 Dec 2010 11:52:48 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
Subject: Re: linux-next: Tree for November 19 (rtmutex)
Message-Id: <20101202115248.f88d7f56.randy.dunlap@oracle.com>
In-Reply-To: <20101119091629.ddf35bec.randy.dunlap@oracle.com>
References: <20101119143207.b2d5731e.sfr@canb.auug.org.au>
	<20101119091629.ddf35bec.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Nov 2010 09:16:29 -0800 Randy Dunlap wrote:

> On Fri, 19 Nov 2010 14:32:07 +1100 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > Changes since 20101118:
> 
> 
> when CONFIG_RT_MUTEXES is not enabled:
> 
> kernel/rtmutex_common.h:81: error: 'struct task_struct' has no member named 'pi_waiters'
> kernel/rtmutex_common.h:87: error: 'struct task_struct' has no member named 'pi_waiters'



This build error still occurs in linux-next 20101202.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
