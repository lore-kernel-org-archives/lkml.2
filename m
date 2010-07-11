Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab0GKWfL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 18:35:11 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:53827 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755414Ab0GKWfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 18:35:08 -0400
Date: Sun, 11 Jul 2010 15:33:16 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for July 9 (staging/ti_st)
Message-Id: <20100711153316.8f54c297.randy.dunlap@oracle.com>
In-Reply-To: <20100709150117.51612026.sfr@canb.auug.org.au>
References: <20100709150117.51612026.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4C3A4716.020F:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Jul 2010 15:01:17 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20100708:
> 
> The infiniband tree gained a build failure so I used the version from
> next-20100708.
> 
> The wireless tree gained a conflict against the net tree.
> 
> The block tree gained a build failure for which I applied a patch.
> 
> The tty tree gained a conflict against the genesis tree.


Can't find this function in the linux-next source tree:

ERROR: "st_get_plat_device" [drivers/staging/ti-st/st_drv.ko] undefined!

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
