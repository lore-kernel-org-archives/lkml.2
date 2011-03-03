Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815Ab1CCK24 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 05:28:56 -0500
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:56274 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751980Ab1CCK2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 05:28:55 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEANb6bk1R8KK1/2dsb2JhbACmdHW+ag2FVAQ
Date: Thu, 3 Mar 2011 11:28:53 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Thomas Mingarelli <Thomas.Mingarelli@hp.com>,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH] watchdog: hpwdt: eliminate section mismatch warning
Message-ID: <20110303102853.GY3790@infomag.iguana.be>
References: <1299037784.16464.1.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299037784.16464.1.camel@mola>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

> hpwdt_init_nmi_decoding() is called in hpwdt_init_one error handling,
> thus remove the  __devexit annotation of hpwdt_exit_nmi_decoding().
> 
> This patch fixes below warning:
> 
> WARNING: drivers/watchdog/hpwdt.o(.devinit.text+0x36f): Section mismatch in reference from the function hpwdt_init_one() to the function .devexit.text:hpwdt_exit_nmi_decoding()

Added to linux-2.6-watchdog-next. Will sent it over to Linus for inclusion in the mainline kernel in a couple of days.

Kind regards,
Wim.

