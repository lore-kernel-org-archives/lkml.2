Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263Ab1DDJx1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 05:53:27 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:60049 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751741Ab1DDJx0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 05:53:26 -0400
Date: Mon, 4 Apr 2011 11:53:22 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: "wanlong.gao" <wanlong.gao@gmail.com>
Cc: davem <davem@davemloft.net>, padovan <padovan@profusion.mobi>,
        joe <joe@perches.com>, marcel <marcel@holtmann.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Re: [PATCH] X86:NET:Replaced a deprecated function .
Message-ID: <20110404095322.GA10089@isilmar-3.linta.de>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	"wanlong.gao" <wanlong.gao@gmail.com>, davem <davem@davemloft.net>,
	padovan <padovan@profusion.mobi>, joe <joe@perches.com>,
	marcel <marcel@holtmann.org>, netdev <netdev@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <20110404093620.GA4896@isilmar-3.linta.de> <201104041743511096883@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201104041743511096883@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 04, 2011 at 05:44:00PM +0800, wanlong.gao wrote:
> You means that some drivers still not capable of IRQF_SHARED?

That's the issue. I do not know whether this driver is capable of
IRQF_SHARED as it should be. If it is, you may replace the
pcmcia_request_exclusive_irq() with pcmcia_request_irq(), and the warning
will be gone.

Best,
	Dominik
