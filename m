Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758596Ab1CCRab (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 12:30:31 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:26728 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757104Ab1CCRaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 12:30:30 -0500
Date: Thu, 3 Mar 2011 09:29:27 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh <greg@kroah.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        driverdevel <devel@driverdev.osuosl.org>
Subject: Re: linux-next: Tree for March 3 (staging/tty/specialix)
Message-Id: <20110303092927.c06dbbf0.randy.dunlap@oracle.com>
In-Reply-To: <20110303180158.ea30ef45.sfr@canb.auug.org.au>
References: <20110303180158.ea30ef45.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4D6FD02D.0340,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Mar 2011 18:01:58 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20110302:


#include "cd1865.h"
=>
linux-next-20110303/drivers/staging/tty/specialix.c:99:20: error: cd1865.h: No such file or directory

This leads to 100 or so errors.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
