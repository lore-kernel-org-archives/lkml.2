Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757917Ab0IZODj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 10:03:39 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:41335 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757792Ab0IZODh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 10:03:37 -0400
Date: Sun, 26 Sep 2010 15:54:44 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Rahul Ruikar <rahul.ruikar@gmail.com>
Cc: komurojun-mbn@nifty.com, w.sang@pengutronix.de, davem@davemloft.net,
        linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pcmcia: pd6729: Fix error path
Message-ID: <20100926135444.GA32380@comet.dominikbrodowski.net>
Mail-Followup-To: Rahul Ruikar <rahul.ruikar@gmail.com>,
	komurojun-mbn@nifty.com, w.sang@pengutronix.de, davem@davemloft.net,
	linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1285500629-6024-1-git-send-email-rahul.ruikar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285500629-6024-1-git-send-email-rahul.ruikar@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 26, 2010 at 05:00:29PM +0530, Rahul Ruikar wrote:
> In error return path
> call pci_disable_device() which was enabled earlier.
> 
> Signed-off-by: Rahul Ruikar <rahul.ruikar@gmail.com>

Applied, thanks!

	Dominik
