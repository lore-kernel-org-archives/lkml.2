Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980Ab2CFFwd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 00:52:33 -0500
Received: from smtp-68.nebula.fi ([83.145.220.68]:50199 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672Ab2CFFwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 00:52:32 -0500
Date: Tue, 6 Mar 2012 07:52:11 +0200
From: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
To: Richard Weinberger <richard@nod.at>
Cc: jonas@southpole.se, linux-kernel@vger.kernel.org, linux@openrisc.net
Subject: Re: [ORLinux] [PATCH] OpenRISC: Handle r0 with care
Message-ID: <20120306055211.GA24532@chokladfabriken.org>
References: <1330981627-16121-1-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330981627-16121-1-git-send-email-richard@nod.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2012 at 10:07:07PM +0100, Richard Weinberger wrote:
> @@ -185,8 +186,8 @@ handler:							;\
>  /* ---[ 0x100: RESET exception ]----------------------------------------- */
>  
>  EXCEPTION_ENTRY(_tng_kernel_start)
> +	l.andi r0,r0,0
>  	l.jal	_start
> -	 l.andi r0,r0,0
>  
>  /* ---[ 0x200: BUS exception ]------------------------------------------- */
>  

The OpenRISC architecture features delay slots, so you probably don't want
to do that.

Stefan
