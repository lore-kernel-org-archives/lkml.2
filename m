Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759416Ab0EEQR7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 12:17:59 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:25222 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755489Ab0EEQR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 12:17:57 -0400
Date: Wed, 5 May 2010 09:17:38 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Eric Biederman <ebiederm@xmission.com>, gregkh@suse.de
Subject: Re: linux-next: Tree for April 30 (CONFIG_SYSFS=n)
Message-Id: <20100505091738.7ec27479.randy.dunlap@oracle.com>
In-Reply-To: <20100430105016.40b51636.randy.dunlap@oracle.com>
References: <20100430163538.7253a9e0.sfr@canb.auug.org.au>
	<20100430105016.40b51636.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A0B0208.4BE19A2B.0001:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Apr 2010 10:50:16 -0700 Randy Dunlap wrote:

> On Fri, 30 Apr 2010 16:35:38 +1000 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > Changes since 20100429:
> 
> 
> When CONFIG_SYSFS is disabled:
> 
> include/linux/sysfs.h:330: error: parameter 1 ('type') has incomplete type


Still have this in linux-next of May 5-2010.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
