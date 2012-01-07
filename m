Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089Ab2AGKA6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 05:00:58 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:33654 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293Ab2AGKA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 05:00:56 -0500
Date: Sat, 7 Jan 2012 11:00:39 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: linux-i2c@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i2c-dev: Use memdup_user
Message-ID: <20120107110039.6b4142f0@endymion.delvare>
In-Reply-To: <1313223430.16820.14.camel@localhost.localdomain>
References: <1313223430.16820.14.camel@localhost.localdomain>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

Sorry for the late reply.

On Sat, 13 Aug 2011 10:17:06 +0200, Thomas Meyer wrote:
> From: Thomas Meyer <thomas@m3y3r.de>
> 
>  Use kmemdup_user rather than duplicating its implementation
>  This is a little bit restricted to reduce false positives
> 
>  The semantic patch that makes this output is available
>  in scripts/coccinelle/api/memdup_user.cocci.
> 
>  More information about semantic patching is available at
>  http://coccinelle.lip6.fr/
> 
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>

Applied, thanks.

-- 
Jean Delvare
