Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757819Ab1CCKj4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 05:39:56 -0500
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:26228 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751800Ab1CCKjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 05:39:55 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAJP+bk1R8KK1/2dsb2JhbACmdHW+aw2FVAQ
Date: Thu, 3 Mar 2011 11:39:50 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Jamie Iles <jamie@jamieiles.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC] [PATCH 1/10] Generic Watchdog Timer Driver
Message-ID: <20110303103950.GB3790@infomag.iguana.be>
References: <20110223204206.GA7138@infomag.iguana.be> <20110224093624.GA15118@pulham.picochip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110224093624.GA15118@pulham.picochip.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jamie,

> Is it worth using pr_fmt() and friends rather than printk() with 
> explicit levels and prefixes throughout the code?


patch 12 :-)

Kind regards,
Wim.

