Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932539Ab1CRVdn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 17:33:43 -0400
Received: from ist.d-labs.de ([213.239.218.44]:34394 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932131Ab1CRVdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 17:33:35 -0400
Date: Fri, 18 Mar 2011 22:33:29 +0100
From: Florian Mickler <florian@mickler.org>
To: Antti Palosaari <crope@iki.fi>
Cc: mchehab@infradead.org, oliver@neukum.org, jwjstone@fastmail.fm,
        linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 05/16] [media] ec168: get rid of on stack dma buffers
Message-ID: <20110318223329.5e400d1e@schatten.dmk.lab>
In-Reply-To: <4D838A25.8010301@iki.fi>
References: <20110315093632.5fc9fb77@schatten.dmk.lab>
	<1300178655-24832-1-git-send-email-florian@mickler.org>
	<1300178655-24832-5-git-send-email-florian@mickler.org>
	<4D838A25.8010301@iki.fi>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Mar 2011 18:36:53 +0200
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
> Acked-by: Antti Palosaari <crope@iki.fi>
> Reviewed-by: Antti Palosaari <crope@iki.fi>
> Tested-by: Antti Palosaari <crope@iki.fi>
> 
> t. Antti
> 

Thanks for the feedback!

Regards,
Flo
