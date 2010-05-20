Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420Ab0ETHwc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 03:52:32 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:20892 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753862Ab0ETHwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 03:52:31 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAIaG9Etbsth3/2dsb2JhbACeA3K8Sg6FBAQ
Date: Thu, 20 May 2010 09:52:29 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Giel van Schijndel <me@mortis.eu>
Cc: Hans de Goede <hdegoede@redhat.com>, Jean Delvare <khali@linux-fr.org>,
       Jonathan Cameron <jic23@cam.ac.uk>, Wim Van Sebroeck <wim@iguana.be>,
       Laurens Leemans <laurens@signips.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] [RFC] watchdog: f71808e_wdt: new watchdog driver
	for Fintek F71808E
Message-ID: <20100520075229.GO4008@infomag.iguana.be>
References: <20100325125005.6d58cfaf@lxorguk.ukuu.org.uk> <1269523063-30346-1-git-send-email-me@mortis.eu> <1269523063-30346-2-git-send-email-me@mortis.eu> <1269523063-30346-3-git-send-email-me@mortis.eu> <20100330090639.GA8822@salidar.me.mortis.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100330090639.GA8822@salidar.me.mortis.eu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Giel,

> On Thu, Mar 25, 2010 at 02:17:43PM +0100, Giel van Schijndel wrote:
> > Add a new watchdog driver for the Fintek F71808E Super I/O chip.
> 
> Updated patch:
>  * fixes a bug where detection wouldn't function properly if a
>    non-Fintek device was found (or a wrong Super I/O port chosen).
>  * Add support for the F71882FG
> 
> NOTE: This patch depends on patch [1] (applied in [2]) and patch [3].
> 
> [1] https://patchwork.kernel.org/patch/89023/
> [2] http://git.kernel.org/?p=linux/kernel/git/jbarnes/pci-2.6.git;a=commit;h=316607809324cc796c0809630b6ae8a768404296
> [3] https://patchwork.kernel.org/patch/88235/

Driver looks OK to me. Can't apply it before the I/O resource sharing is in place.
How do you want to proceed?

Kind regards,
Wim.

