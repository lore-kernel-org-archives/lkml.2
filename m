Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529Ab1CRV10 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 17:27:26 -0400
Received: from ist.d-labs.de ([213.239.218.44]:36995 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757444Ab1CRV1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 17:27:22 -0400
Date: Fri, 18 Mar 2011 22:27:13 +0100
From: Florian Mickler <florian@mickler.org>
To: Antti Palosaari <crope@iki.fi>
Cc: mchehab@infradead.org, oliver@neukum.org, jwjstone@fastmail.fm,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 09/16] [media] au6610: get rid of on-stack dma buffer
Message-ID: <20110318222713.4c51f1ed@schatten.dmk.lab>
In-Reply-To: <4D8389B2.60507@iki.fi>
References: <20110315093632.5fc9fb77@schatten.dmk.lab>
	<1300178655-24832-1-git-send-email-florian@mickler.org>
	<1300178655-24832-9-git-send-email-florian@mickler.org>
	<4D8389B2.60507@iki.fi>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Mar 2011 18:34:58 +0200
Antti Palosaari <crope@iki.fi> wrote:

> On 03/15/2011 10:43 AM, Florian Mickler wrote:
> > usb_control_msg initiates (and waits for completion of) a dma transfer using
> > the supplied buffer. That buffer thus has to be seperately allocated on
> > the heap.
> >
> > In lib/dma_debug.c the function check_for_stack even warns about it:
> > 	WARNING: at lib/dma-debug.c:866 check_for_stack
> >
> > Note: This change is tested to compile only, as I don't have the hardware.
> >
> > Signed-off-by: Florian Mickler<florian@mickler.org>
> 
> 
> This patch did not found from patchwork! Probably skipped due to broken 
> Cc at my contact. Please resend.
> 
> Anyhow, I tested and reviewed it.
> 
> Acked-by: Antti Palosaari <crope@iki.fi>
> Reviewed-by: Antti Palosaari <crope@iki.fi>
> Tested-by: Antti Palosaari <crope@iki.fi>
> 
> [1] https://patchwork.kernel.org/project/linux-media/list/
> 
> Antti
> 

Yes, there was some broken adressing on my side. Sorry. 

Thanks for review && test!  I will resend (hopefully this weekend) the
series when I reviewed some of the other patches if it is
feasible/better to use prealocated memory as suggested by Mauro. 

How often does au6610_usb_msg get called in normal operation? Should it
use preallocated memory?

Regards,
Flo
