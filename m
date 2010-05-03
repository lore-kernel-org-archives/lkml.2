Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950Ab0ECSLN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 14:11:13 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:39268 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755712Ab0ECSLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 14:11:11 -0400
Date: Mon, 3 May 2010 11:06:57 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de,
       devel@driverdev.osuosl.org, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, support@sbei.com,
       support@onestopsystems.com
Subject: Re: [PATCH -next] staging: fix cxt1e1 module names
Message-Id: <20100503110657.00b4e140.randy.dunlap@oracle.com>
In-Reply-To: <1272909764.30040.92.camel@Joe-Laptop.home>
References: <20100503151619.f75e3a80.sfr@canb.auug.org.au>
	<20100503100902.517c146f.randy.dunlap@oracle.com>
	<1272909764.30040.92.camel@Joe-Laptop.home>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090203.4BDF114C.0155:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 May 2010 11:02:44 -0700 Joe Perches wrote:

> On Mon, 2010-05-03 at 10:09 -0700, Randy Dunlap wrote:
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > Lots of cxt1e1 source code uses THIS_MODULE->name, which won't build
> > when CONFIG_MODULES is not enabled, so use KBUILD_MODNAME instead.
> 
> Perhaps a conversion to pr_<level> is better?

Sure, fine with me.  Thanks.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
