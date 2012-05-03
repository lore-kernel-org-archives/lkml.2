Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283Ab2ECLDj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 07:03:39 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:55783 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757221Ab2ECLDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 07:03:38 -0400
Date: Thu, 3 May 2012 13:03:36 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH] watchdog: sp5100_tco.c: quiet sparse noise about using plain integer was NULL pointer
Message-ID: <20120503110336.GL3074@spo001.leaseweb.com>
References: <201205021654.43838.hartleys@visionengravers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201205021654.43838.hartleys@visionengravers.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Pointers should not be compared to plain integers.
> Quiets the sparse warning:
> warning: Using plain integer as NULL pointer
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Wim Van Sebroeck <wim@iguana.be>

Added to linux-watchdog-next.

Kind regards,
Wim.

