Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab0C2Skp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 14:40:45 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:21266 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750957Ab0C2Skn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 14:40:43 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAIGPsEtR9cAU/2dsb2JhbACbJHLAUg2EdAQ
Date: Mon, 29 Mar 2010 20:40:41 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Giel van Schijndel <me@mortis.eu>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] doc: watchdog simple example: don't fail on fsync()
Message-ID: <20100329184041.GU3823@infomag.iguana.be>
References: <1269260557-18150-1-git-send-email-me@mortis.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269260557-18150-1-git-send-email-me@mortis.eu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Giel,

> Don't terminate the watchdog daemon when fsync() fails because no
> watchdog driver actually implements the fsync() syscall.

Wouldn't it be simpler then to just do an fsync without checking the error-result?

Kind regards,
Wim.


