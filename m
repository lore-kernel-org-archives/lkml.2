Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180Ab0DSTUA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 15:20:00 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:59141 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753870Ab0DSTT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 15:19:59 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAJJIzEtbstew/2dsb2JhbACbe3K9Jw2FAQQ
Date: Mon, 19 Apr 2010 21:19:56 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: alan@redhat.com, andy.sharp@onstor.com, linux-kernel@vger.kernel.org,
       linux-mips@vger.kernel.org, ralf@linux-mips.org
Subject: Re: [PATCH/RESEND] MIPS: Fix sibyte watchdog initialization
Message-ID: <20100419191956.GK15728@infomag.iguana.be>
References: <1271691431-28166-1-git-send-email-guenter.roeck@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271691431-28166-1-git-send-email-guenter.roeck@ericsson.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

> Watchdog configuration register and timer count register were interchanged,
> causing wrong values to be written into both registers.
> This caused watchdog triggered resets even if the watchdog was reset in time.
> 
> Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>

Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Just let me know when this can be added as a fix in the watchdog tree.

Kind regards,
Wim.

