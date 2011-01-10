Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460Ab1AJH1x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 02:27:53 -0500
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:54230 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750852Ab1AJH1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 02:27:52 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAM9DKk1R8G9r/2dsb2JhbACkPnS7EA2FPwQ
Date: Mon, 10 Jan 2011 08:27:50 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Philippe De Muyter <phdm@macqel.be>
Subject: Re: linux-next: build failure after merge of the watchdog tree
Message-ID: <20110110072750.GL3801@infomag.iguana.be>
References: <20110110141250.78947d61.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110110141250.78947d61.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

> After merging the watchdog tree, today's linux-next build (x86_64
> allmodconfig) failed like this:

This driver is for the m68K architecture. I apparently missed checking
the dependancy in Kconfig. I'll fix it today.

Kind regards,
Wim.

