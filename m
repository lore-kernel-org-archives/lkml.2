Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab0EUItg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 04:49:36 -0400
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:33362 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751246Ab0EUIte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 04:49:34 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEADbk9UtbssDi/2dsb2JhbACeH3K9Dg6FBAQ
Date: Fri, 21 May 2010 10:49:32 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH] [WATCHDOG] bfin: use new common Blackfin watchdog
	header
Message-ID: <20100521084932.GP3972@infomag.iguana.be>
References: <1268150860-28011-1-git-send-email-vapier@gentoo.org> <1274430208-15087-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274430208-15087-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
> Andrew: could you pick this up ?  it was posted a few months ago ...

This is allready in the linux-2.6-watchdog tree. I'm reviewing a last driver
and will then sent a pull request to Linus.

Kind regards,
Wim.

