Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab1BUR5q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 12:57:46 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:59552 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299Ab1BUR5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 12:57:44 -0500
Date: Mon, 21 Feb 2011 09:57:32 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, lud <linux-usb@vger.kernel.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for February 21 (usb/serial)
Message-Id: <20110221095732.b3842652.randy.dunlap@oracle.com>
In-Reply-To: <20110221182134.09abd232.sfr@canb.auug.org.au>
References: <20110221182134.09abd232.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4D62A791.0281:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Feb 2011 18:21:34 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20110218:


When CONFIG_PM_RUNTIME is not enabled:

drivers/usb/serial/usb_wwan.c:702: error: 'struct dev_pm_info' has no member named 'usage_count'

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
