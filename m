Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920Ab0KSRSb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 12:18:31 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:40519 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755465Ab0KSRS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 12:18:29 -0500
Date: Fri, 19 Nov 2010 09:16:29 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for November 19 (rtmutex)
Message-Id: <20101119091629.ddf35bec.randy.dunlap@oracle.com>
In-Reply-To: <20101119143207.b2d5731e.sfr@canb.auug.org.au>
References: <20101119143207.b2d5731e.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Nov 2010 14:32:07 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20101118:


when CONFIG_RT_MUTEXES is not enabled:

kernel/rtmutex_common.h:81: error: 'struct task_struct' has no member named 'pi_waiters'
kernel/rtmutex_common.h:87: error: 'struct task_struct' has no member named 'pi_waiters'

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
