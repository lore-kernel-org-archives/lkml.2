Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab2HFN4D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 09:56:03 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:25886 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756178Ab2HFN4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 09:56:00 -0400
Date: Mon, 6 Aug 2012 16:55:56 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Devendra Naga <develkernel412222@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Veli-Pekka Peltola <veli-pekka.peltola@bluegiga.com>,
        Mikko =?iso-8859-1?Q?Virkkil=E4?= <mikko.virkkila@bluegiga.com>,
        Riku =?iso-8859-1?Q?Mett=E4l=E4?= <riku.mettala@bluegiga.com>,
        Lauri Hintsala <Lauri.Hintsala@bluegiga.com>
Subject: Re: [PATCH 1/5] staging/csr: clean coding style in uf_start_thread
Message-ID: <20120806135556.GA9956@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was sent encoded as base64 which is awkward.

On Sat, Aug 04, 2012 at 01:01:38PM +0545, Devendra Naga wrote:
> -    } else {
> -        priv->bh_thread.prio = DEFAULT_PRIO;
> -    }
> +	} else
> +		priv->bh_thread.prio = DEFAULT_PRIO;

Probably it's not worth resending if this is the only complaint, but
actually the original had that braces correct.  If either side of
the if else statement gets uses curly braces then both sides should
use them.

regards,
dan carpenter
