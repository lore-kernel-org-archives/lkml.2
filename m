Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942Ab2JJToV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 15:44:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53581 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756238Ab2JJToS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 15:44:18 -0400
From: Oliver Neukum <oneukum@suse.de>
To: jc@eclis.ch
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH] Add CDC-ACM support for the CX93010-2x UCMxx USB Modem
Date: Wed, 10 Oct 2012 21:42:32 +0200
Message-ID: <16666667.izGXgx19Gh@linux-lqwf.site>
Organization: SUSE
User-Agent: KMail/4.8.4 (Linux/3.6.0-rc4-12-desktop+; KDE/4.9.1; x86_64; ; )
In-Reply-To: <1348841764-26873-1-git-send-email-jc@eclis.ch>
References: <1348841764-26873-1-git-send-email-jc@eclis.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 September 2012 16:16:04 jc@eclis.ch wrote:
> From: Jean-Christian de Rivaz <jc@eclis.ch>
> 
> This USB V.92/V.32bis Controllered Modem have the USB vendor ID 0x0572
> and device ID 0x1340. It need the NO_UNION_NORMAL quirk to be recognized.
> 
> Reference:
> http://www.conexant.com/servlets/DownloadServlet/DSH-201723-005.pdf?docid=1725&revid=5
> 
> Signed-off-by: Jean-Christian de Rivaz <jc@eclis.ch>
Acked-by: Oliver Neukum <oneukum@SUSE.DE>

However, this went to the wrong list. Please repost to

davem@davemloft.net
netdev@vger.kernel.org

	Regards
		Oliver

