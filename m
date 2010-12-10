Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185Ab0LJNXU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 08:23:20 -0500
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:31497 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753734Ab0LJNXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 08:23:19 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAJK3AU1R8iIQ/2dsb2JhbACDXKAkea5GkFoNgRSDNXQEkBNs
Date: Fri, 10 Dec 2010 14:23:16 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] [WATCHDOG] fix compiler warning on ali_pci_tbl
Message-ID: <20101210132316.GB3783@infomag.iguana.be>
References: <1291739256-16380-1-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1291739256-16380-1-git-send-email-namhyung@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kim,

> Annotate ali_pci_tbl as '__used' to fix following warning:
> 
>   CC      drivers/watchdog/alim1535_wdt.o
> drivers/watchdog/alim1535_wdt.c:304: warning: ‘ali_pci_tbl’ defined but not used
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>

Will be added to linux-2.6-watchdog-next.

Kind regards,
Wim.

