Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345Ab0GAX3A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 19:29:00 -0400
Received: from koto.vergenet.net ([210.128.90.7]:43843 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753842Ab0GAX25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 19:28:57 -0400
Date: Fri, 2 Jul 2010 08:28:56 +0900
From: Simon Horman <horms@verge.net.au>
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: Kernel Janitors <kernel-janitors@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Julia Lawall <julia@diku.dk>,
       Joe Perches <joe@perches.com>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/16] staging/otus: use ARRAY_SIZE
Message-ID: <20100701232856.GF27096@verge.net.au>
References: <1277983377-29390-1-git-send-email-segooon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277983377-29390-1-git-send-email-segooon@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 01, 2010 at 03:22:55PM +0400, Kulikov Vasiliy wrote:
> Change sizeof(x) / sizeof(*x) to ARRAY_SIZE(x).
> 
> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>

FWIW, Reviewed-by: Simon Horman <horms@verge.net.au>
