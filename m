Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229Ab2KVVGI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:06:08 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:42236 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756038Ab2KVVGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 16:06:06 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+ukrw9eymuSiTGJJlL4H7ODZ9i48LDr4VJB2ttkP
	notrAgp45dQc/Z
From: Peter Huewe <PeterHuewe@gmx.de>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH] TPM: Switch to __packed instead of __attribute__((packed))
Date: Wed, 21 Nov 2012 23:50:24 +0100
User-Agent: KMail/1.13.7 (Linux/3.6.7; KDE/4.8.5; x86_64; ; )
Cc: Peter.Huewe@infineon.com, key@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
References: <20121121205645.GB15285@obsidianresearch.com>
In-Reply-To: <20121121205645.GB15285@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201211212350.24836.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 21. November 2012, 21:56:45 schrieb Jason Gunthorpe:
> This seems to be preferred these days.
> 
> Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

Looks good to me
Reviewed-by: Peter Huewe <peterhuewe@gmx.de>

Thanks,
Peter
