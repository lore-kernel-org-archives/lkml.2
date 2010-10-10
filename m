Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751645Ab0JJS6a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 14:58:30 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:62321 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab0JJS63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 14:58:29 -0400
Date: Sun, 10 Oct 2010 11:56:18 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        driverdevel <devel@driverdev.osuosl.org>, gregkh <greg@kroah.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Vinod Koul <vinod.koul@intel.com>,
        Harsha Priya <priya.harsha@intel.com>,
        Dharageswari R <dharageswari.r@intel.com>
Subject: Re: linux-next: Tree for October 8 (staging/intel_sst)
Message-Id: <20101010115618.b048a89e.randy.dunlap@oracle.com>
In-Reply-To: <20101008161552.07c9f137.sfr@canb.auug.org.au>
References: <20101008161552.07c9f137.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Oct 2010 16:15:52 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20101007:


drivers/staging/intel_sst/intel_sst_drv_interface.c:88: error: implicit declaration of function 'msleep'

needs
#include <linux/delay.h>


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
