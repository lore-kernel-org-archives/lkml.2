Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813Ab0HRFxV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 01:53:21 -0400
Received: from lvps87-230-0-242.dedicated.hosteurope.de ([87.230.0.242]:47431
	"EHLO lvps87-230-0-242.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751608Ab0HRFxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 01:53:13 -0400
Date: Wed, 18 Aug 2010 07:53:02 +0200
From: Michael Guntsche <mike@it-loops.com>
To: Brian Norris <norris@broadcom.com>
Cc: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] Nand support broken with v2.6.36-rc1
Message-ID: <20100818055302.GA24116@gibson.comsick.at>
References: <20100817113644.GA31317@gibson.comsick.at>
 <4C6AC037.7070205@broadcom.com>
 <20100817174704.GA1322@gibson.comsick.at>
 <4C6AD9C2.1070705@broadcom.com>
 <20100817200559.GA4542@gibson.comsick.at>
 <4C6B024A.7040505@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C6B024A.7040505@broadcom.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 Aug 10 14:42, Brian Norris wrote:
> In place of that, though, you can just try this patch on 2.6.36-rc1.
> I believe it should satisfy the intention of my previous (faulty)
> commit while reverting the regression behavior. If this works OK, I
> will submit it to be included in the mainline kernel.

Hi Brian,

Applying this patch fixes the problem for me. I removed my workaround
and just tried your patch and was able to mount both mtdblock devices.

Thank you for fixing this,
Michael Guntsche
