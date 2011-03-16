Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024Ab1CPQRW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 12:17:22 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:23824 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441Ab1CPQRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 12:17:16 -0400
Date: Wed, 16 Mar 2011 09:16:44 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jean Delvare <khali@linux-fr.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
Subject: Re: linux-next: build failure after merge of the final tree
 (jdelvare-hwmon tree related)
Message-Id: <20110316091644.d050115e.randy.dunlap@oracle.com>
In-Reply-To: <20110315192428.ce74a177.sfr@canb.auug.org.au>
References: <20110315192428.ce74a177.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4D80E270.020F,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Mar 2011 19:24:28 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> drivers/hwmon/sch5627.c: In function 'sch5627_read_virtual_reg':
> drivers/hwmon/sch5627.c:179: error: implicit declaration of function 'msleep'
> 
> Caused by commit 19803daeb145 ("hwmon: New driver for SMSC SCH5627").
> See Rule 1 in Documentation/SubmitChecklist.
> 
> I have reverted that commit for today.


linux-next-20110316/drivers/i2c/busses/i2c-designware-core.c:321: error: implicit declaration of function 'mdelay'

linux-next-20110316/drivers/staging/altera-stapl/altera-jtag.c:398: error: implicit declaration of function 'udelay'

patch has been posted for altera-jtag.c, but not merged.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
