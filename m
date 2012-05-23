Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760736Ab2EWSg0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 14:36:26 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:54185 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756356Ab2EWSgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 14:36:24 -0400
Date: Wed, 23 May 2012 20:36:23 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        Anthony Olech <Anthony.Olech@diasemi.com>, sameo@linux.intel.com
Subject: Re: [PATCH] Watchdog: Fix for settimeout issue
Message-ID: <20120523183623.GN3074@spo001.leaseweb.com>
References: <1335768031.9546.20.camel@dhruva>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335768031.9546.20.camel@dhruva>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ashish,

> Some devices have a fixed minimum elapse time and a ping before this
> elapse time causes error condition. This patch fix this issue in the
> settimeout operation.

Won't add this patch. The driver needs to take care of the mdelay.
PS: for da9052_wdt: start (=set_timeout) + ping will also give you
the same problem.

Kind regards,
Wim.

