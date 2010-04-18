Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab0DRUyc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 16:54:32 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:55578 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753595Ab0DRUyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 16:54:25 -0400
Date: Sun, 18 Apr 2010 22:04:49 +0200
From: Harald Welte <laforge@gnumonks.org>
To: Dan Carpenter <error27@gmail.com>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       H Hartley Sweeten <hsweeten@visionengravers.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roel Kluin <roel.kluin@gmail.com>, Jiri Slaby <jirislaby@gmail.com>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] pcmcia: fix error handling in cm4000_cs.c
Message-ID: <20100418200449.GA18200@prithivi.gnumonks.org>
References: <20100418190732.GA7920@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100418190732.GA7920@bicker>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

On Sun, Apr 18, 2010 at 10:07:33PM +0300, Dan Carpenter wrote:

> In the original code we used -ENODEV as the number of bytes to
> copy_to_user() and we didn't release the locks.

Thanks for pointing this out!
 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Acked-by: Harald Welte <laforge@gnumonks.org>

-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
