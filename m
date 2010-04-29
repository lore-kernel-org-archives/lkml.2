Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759382Ab0D3TAt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 15:00:49 -0400
Received: from kroah.org ([198.145.64.141]:49557 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932577Ab0D3RDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:03:33 -0400
Date: Thu, 29 Apr 2010 12:10:43 -0700
From: Greg KH <greg@kroah.com>
To: Yoichi Yuasa <yuasa@linux-mips.org>
Cc: Naren Sankar <nsankar@broadcom.com>, Jarod Wilson <jarod@wilsonet.com>,
       Scott Davilla <davilla@4pi.com>, Manu Abraham <abraham.manu@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/11] staging: crystalhd: remove unused bc_dts_types.h
Message-ID: <20100429191043.GF21799@kroah.com>
References: <20100425221851.223dc284.yuasa@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100425221851.223dc284.yuasa@linux-mips.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 25, 2010 at 10:18:51PM +0900, Yoichi Yuasa wrote:
> Signed-off-by: Yoichi Yuasa <yuasa@linux-mips.org>
> ---
>  drivers/staging/crystalhd/bc_dts_defs.h  |    2 -
>  drivers/staging/crystalhd/bc_dts_types.h |  121 ------------------------------

Wait, all crystalhd patches should go through Ralf's tree, can you send
these to him instead?

thanks,

greg k-h
