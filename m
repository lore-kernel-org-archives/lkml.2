Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182Ab0GMRhA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 13:37:00 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:47165 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001Ab0GMRg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 13:36:59 -0400
Date: Tue, 13 Jul 2010 10:36:23 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Takashi Iwai <tiwai@suse.de>,
        Jaroslav Kysela <perex@perex.cz>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for July 13 (sound/oss/msnd_pinnacle)
Message-Id: <20100713103623.bfb0d9b8.randy.dunlap@oracle.com>
In-Reply-To: <20100713144007.55d3abc9.sfr@canb.auug.org.au>
References: <20100713144007.55d3abc9.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4C3CA42D.00D4:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jul 2010 14:40:07 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Not unexpectedly, we got some conflicts with the arm defconfig files
> today ...


sound/oss/msnd_pinnacle.c:644:error: 'inode' undeclared (first use in this function)


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
