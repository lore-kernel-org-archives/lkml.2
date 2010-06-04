Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897Ab0FDFUq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 01:20:46 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:33403 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528Ab0FDFUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 01:20:44 -0400
Date: Fri, 4 Jun 2010 14:20:18 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: mingo@elte.hu, akpm@linux-foundation.org, simon.kagstrom@netinsight.net,
       David.Woodhouse@intel.com, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org
Subject: Re: [PATCH v3] printk: fix delayed messages from CPU hotplug events
Message-ID: <20100604052018.GA2565@linux-sh.org>
References: <ee1bf4f9c158983acad0a4548229586128afad67@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee1bf4f9c158983acad0a4548229586128afad67@localhost>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 10:11:25PM -0700, Kevin Cernekee wrote:
> [Changes from v2:
> 
> Use hotcpu_notifier - fix will only apply to hotplug events, not
> initial SMP boot
> 
With the hotcpu notifier it looks good to me.

Reviewed-by: Paul Mundt <lethal@linux-sh.org>
