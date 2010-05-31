Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294Ab0EaLjT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 07:39:19 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:13200 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751419Ab0EaLjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 07:39:17 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEACo9A0xbstGb/2dsb2JhbACeMXLAew6FCAQ
Date: Mon, 31 May 2010 13:39:15 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Julia Lawall <julia@diku.dk>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/11] drivers/watchdog: Eliminate a NULL pointer
	dereference
Message-ID: <20100531113915.GS3972@infomag.iguana.be>
References: <Pine.LNX.4.64.1005271432100.5422@ask.diku.dk> <20100531112330.GI3489@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100531112330.GI3489@rakim.wolfsonmicro.main>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

> > From: Julia Lawall <julia@diku.dk>
> > 
> > At the point of the call to dev_err, wm8350 is NULL.
> 
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Will add this one in linux-2.6-watchdog-next for testing and sent it to Linus after a couple of days.

Kind regards,
Wim.

