Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891Ab1GVSdB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 14:33:01 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:20585 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754674Ab1GVSc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 14:32:59 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAOLAKU5tgwKe/2dsb2JhbABTp0Z4iHwCunoOhVJfBJsfiDA
Date: Fri, 22 Jul 2011 20:32:57 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Paul Mundt <lethal@linux-sh.org>
Cc: David Engraf <david.engraf@sysgo.com>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH] shwdt: fix usage of mod_timer
Message-ID: <20110722183257.GF31767@infomag.iguana.be>
References: <4E26D22B.1040702@sysgo.com> <20110721075353.GC27831@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110721075353.GC27831@linux-sh.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

> On Wed, Jul 20, 2011 at 03:03:39PM +0200, David Engraf wrote:
> > This patch fixes the usage of mod_timer and makes the driver usable. 
> > mod_timer must be called with an absolute timeout in jiffies, the old 
> > implementation used a relative timeout thus the hardware watchdog was 
> > never triggered.
> > 
> > Signed-off-by: David Engraf <david.engraf@sysgo.com>
> > 
> Applied, thanks.

So this patch will go via your tree then.

Kind regards,
Wim.

