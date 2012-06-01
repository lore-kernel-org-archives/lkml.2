Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759947Ab2FAOFK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 10:05:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15510 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754623Ab2FAOFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 10:05:08 -0400
Date: Fri, 1 Jun 2012 10:04:44 -0400
From: Dave Jones <davej@redhat.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: vma_resv_map bug.
Message-ID: <20120601140444.GA1732@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Fengguang Wu <fengguang.wu@intel.com>,
	Dave Hansen <dave@linux.vnet.ibm.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20120530052716.GA12771@redhat.com>
 <20120601091332.GA14623@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120601091332.GA14623@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2012 at 05:13:32PM +0800, Fengguang Wu wrote:
 
 > The same error here. Here is my dmesg. Hope it helps.
 > 
 > [  497.674360] trinity-child0 (31412): Using mlock ulimits for SHM_HUGETLB is deprecated
 > [  502.461866] warning: process `trinity-child0' used the deprecated sysctl system call with 
 > [  502.576500] BUG: unable to handle kernel NULL pointer dereference at 0000000000000030
 > [  502.577028] IP: [<ffffffff81135bed>] vma_resv_map+0x9/0x2b


This should be fixed a few days ago by 4523e1458566a0e8ecfaff90f380dd23acc44d27 

	Dave
