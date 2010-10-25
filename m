Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758271Ab0JYXfH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 19:35:07 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:45796 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab0JYXfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 19:35:04 -0400
Date: Mon, 25 Oct 2010 16:33:39 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, coda@cs.cmu.edu
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for October 25 (coda)
Message-Id: <20101025163339.a2ffca49.randy.dunlap@oracle.com>
In-Reply-To: <20101025145834.9b68e026.sfr@canb.auug.org.au>
References: <20101025145834.9b68e026.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Oct 2010 14:58:34 +1100 Stephen Rothwell wrote:

> Hi all,

The coda BKL fixes (git tree) are not in here yet, right?

fs/coda/* currently has 12 warnings like these:

fs/coda/psdev.c:140: error: implicit declaration of function 'lock_kernel'
fs/coda/psdev.c:142: error: implicit declaration of function 'unlock_kernel'

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
