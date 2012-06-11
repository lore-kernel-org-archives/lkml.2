Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab2FKP5v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 11:57:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55570 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659Ab2FKP5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 11:57:49 -0400
Date: Mon, 11 Jun 2012 08:51:28 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linus.walleij@stericsson.com,
        Grant Likely <grant.likely@secretlab.ca>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com
Subject: Re: [PATCH 01/14] rtc: ab8500-rtc: IRQF_ONESHOT when requesting a
 threaded IRQ
Message-ID: <20120611155128.GA18005@kroah.com>
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org>
 <1339428307-3850-2-git-send-email-lee.jones@linaro.org>
 <201206111531.20468.arnd@arndb.de>
 <4FD610AE.7010001@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FD610AE.7010001@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 04:37:18PM +0100, Lee Jones wrote:
> On 11/06/12 16:31, Arnd Bergmann wrote:
> >On Monday 11 June 2012, Lee Jones wrote:
> >>The kernel now forces IRQs to be ONESHOT if no IRQ handler is passed.
> >>
> >>Cc: Alessandro Zummo<a.zummo@towertech.it>
> >>Cc: rtc-linux@googlegroups.com
> >>Signed-off-by: Lee Jones<lee.jones@linaro.org>
> >
> >Isn't this a bug fix that should be applied to the stable kernels too?
> 
> Possibly. Should we alert Greg (CC'ed - alerted)?

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
