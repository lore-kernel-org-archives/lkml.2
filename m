Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242Ab2BEVzG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 16:55:06 -0500
Received: from isilmar-3.linta.de ([188.40.101.200]:38685 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751851Ab2BEVyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 16:54:39 -0500
Date: Sun, 5 Feb 2012 22:14:15 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Maxime Bizon <mbizon@freebox.fr>,
        Arjan Van De Ven <arjanv@redhat.com>,
        Jun Komuro <komurojun-mbn@nifty.com>,
        Yoichi Yuasa <yuasa@linux-mips.org>, linux-pcmcia@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] pcmcia: Convert to DEFINE_PCI_DEVICE_TABLE
Message-ID: <20120205211415.GC13598@comet.dominikbrodowski.net>
Mail-Followup-To: Axel Lin <axel.lin@gmail.com>,
	linux-kernel@vger.kernel.org, Maxime Bizon <mbizon@freebox.fr>,
	Arjan Van De Ven <arjanv@redhat.com>,
	Jun Komuro <komurojun-mbn@nifty.com>,
	Yoichi Yuasa <yuasa@linux-mips.org>,
	linux-pcmcia@lists.infradead.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <1324973866.2351.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324973866.2351.3.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 27, 2011 at 04:17:46PM +0800, Axel Lin wrote:
> Convert static struct pci_device_id *[] to static DEFINE_PCI_DEVICE_TABLE
> tables. Also convert to use PCI_DEVICE macro for better readablity.

Applied, thanks.

Best,
	Dominik
