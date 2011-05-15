Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab1EPDys (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 23:54:48 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42363 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab1EPDyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 23:54:45 -0400
Date: Sun, 15 May 2011 15:27:28 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/gpio/Kconfig: remove redundant depends on GPIOLIB
Message-ID: <20110515212728.GC30725@angua.secretlab.ca>
References: <201105131137.28730.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105131137.28730.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 11:37:28AM -0700, H Hartley Sweeten wrote:
> Since all the drivers are in a 'if GPIOLIB/endif block', the depends on GPIOLIB
> is redundant so remove them.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>

Merged, thanks.

g.

