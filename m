Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475Ab2EJDJ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 23:09:58 -0400
Received: from linux-sh.org ([111.68.239.195]:36083 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754454Ab2EJDJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 23:09:54 -0400
Date: Thu, 10 May 2012 12:09:39 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        linux-sh@vger.kernel.org, Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH 5/9 v3] serial: sh-sci: prepare for conversion to the
 shdma base library
Message-ID: <20120510030938.GH7988@linux-sh.org>
References: <1336576161-27082-1-git-send-email-g.liakhovetski@gmx.de>
 <1336576161-27082-6-git-send-email-g.liakhovetski@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336576161-27082-6-git-send-email-g.liakhovetski@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 05:09:17PM +0200, Guennadi Liakhovetski wrote:
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Alan Cox <alan@linux.intel.com>
> ---
>  drivers/tty/serial/sh-sci.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
Acked-by: Paul Mundt <lethal@linux-sh.org>
