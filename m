Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751428Ab0IXEnt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 00:43:49 -0400
Received: from lo.gmane.org ([80.91.229.12]:38142 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837Ab0IXEns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 00:43:48 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Guenter Roeck <guenter.roeck@ericsson.com>
Subject: Re: [PATCH] x86/hwmon: fix module init =?utf-8?b?Zm9yCQ==?= hotplug-but-no-device-found case
Date: Fri, 24 Sep 2010 04:43:34 +0000 (UTC)
Message-ID: <loom.20100924T063847-735@post.gmane.org>
References: <4C8E139F0200007800015AA5@vpn.id2.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 68.124.176.202 (Mozilla/5.0 (Windows NT 5.1; rv:2.0b6) Gecko/20100101 Firefox/4.0b6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich <JBeulich <at> novell.com> writes:

> 
> In commit 0dca94baeab4a1a514841b0a4c8e3a51dfb4d5ae the call to
> platform_driver_unregister() was made conditional upon !HOTPLUG_CPU,
> but the return value from coretemp_init() was left to indicate an
> error. This isn't correct, as the negative return value indicates to
> the module loader that initialization failed, which isn't intended
> here and results in dangling pointers.
> 
> Signed-off-by: Jan Beulich <jbeulich <at> novell.com>
> Cc: Chen Gong <gong.chen <at> linux.intel.com>
> 
I have not seen an Acked-by or Nacked-by for this patch or any other patch from
this series from Jan. 

Discussions indicate that the patches are ok. Unless I hear an explicit Nack,
I'll review the patches and apply them if I think they make sense.

Guenter


