Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab0JKQaj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 12:30:39 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:60609 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755366Ab0JKQah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 12:30:37 -0400
Date: Mon, 11 Oct 2010 09:29:15 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, dri-devel@lists.freedesktop.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        David Airlie <airlied@linux.ie>
Subject: Re: linux-next: Tree for October 11 (nouveau)
Message-Id: <20101011092915.66afd35b.randy.dunlap@oracle.com>
In-Reply-To: <20101011162959.86e40961.sfr@canb.auug.org.au>
References: <20101011162959.86e40961.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Oct 2010 16:29:59 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20101008:


When CONFIG_HWMON is not enabled:

drivers/built-in.o: In function `nouveau_pm_fini':
(.text+0x1c680f): undefined reference to `hwmon_device_unregister'
drivers/built-in.o: In function `nouveau_hwmon_init':
nouveau_pm.c:(.text+0x1c6f93): undefined reference to `hwmon_device_register'
nouveau_pm.c:(.text+0x1c7094): undefined reference to `hwmon_device_unregister'


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
