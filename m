Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317Ab0EYPvA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 11:51:00 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:57340 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873Ab0EYPu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 11:50:59 -0400
Date: Tue, 25 May 2010 08:49:59 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-pm@lists.linux-foundation.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: linux-next: Tree for May 25 (kernel/power, SUSPEND=n)
Message-Id: <20100525084959.4ff9e924.randy.dunlap@oracle.com>
In-Reply-To: <20100525142657.c2ae7804.sfr@canb.auug.org.au>
References: <20100525142657.c2ae7804.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A0B0203.4BFBF1B4.0316:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 May 2010 14:26:57 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> We are in the merge window again.  I remind you all not to add stuff for
> 2.6.36 to your linux-next trees until after 2.6.35-rc1.


when CONFIG_SUSPEND=n, CONFIG_OPPORTUNISTIC_SUSPEND=n, CONFIG_PM=y:

kernel/power/main.c:66: error: 'pm_states' undeclared (first use in this function)


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
