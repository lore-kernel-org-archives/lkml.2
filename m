Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386Ab0HDQs5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 12:48:57 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:24365 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755716Ab0HDQsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 12:48:55 -0400
Date: Wed, 4 Aug 2010 09:47:55 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for August 4 (olpc_battery)
Message-Id: <20100804094755.e0377eb0.randy.dunlap@oracle.com>
In-Reply-To: <20100804151035.14678528.sfr@canb.auug.org.au>
References: <20100804151035.14678528.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4C5999EF.00E9:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Aug 2010 15:10:35 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> As the merge window is open, please do not add 2.6.27 material to your
> linux-next included trees until after 2.6.36-rc1.
> 
> Changes since 20100803:


drivers/power/olpc_battery.c:387: error: unknown field 'owner' specified in initializer
drivers/power/olpc_battery.c:387: warning: excess elements in struct initializer
drivers/power/olpc_battery.c:387: warning: (near initialization for 'olpc_bat_eeprom.attr')


The .owner field has been dropped from the attr struct.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
