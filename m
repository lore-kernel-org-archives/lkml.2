Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753Ab0DONKX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 09:10:23 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:6665 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab0DONKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 09:10:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=Fw2ZUmGclR+EoOnGgVE5GstFg7Xwjvgb2XHcZnD5ILKM1h9IGPwmIrgSC7Itpy8Cez
         AX/Q9ZB5vmuUmSf9ZNF4tt3dFU/k6gfip3JQWK2LPhQ7Y/9BU/GPeVr2OHQmGlMQ/ezI
         uEOYrbfZwq6ghTbp87F0HBFv0ECcRLfYTSu/I=
MIME-Version: 1.0
In-Reply-To: <c2d04a7116b74b3717366148db5f7e54@localhost>
References: <c2d04a7116b74b3717366148db5f7e54@localhost>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Thu, 15 Apr 2010 21:10:00 +0800
Message-ID: <o2mf17812d71004150610z10e5f7a2g42057911d1bc185@mail.gmail.com>
Subject: Re: [PATCH] gpio: max732x: fix input configuration for open-drain 
	pins
To: Marc Zyngier <maz@misterjones.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 16, 2010 at 5:19 PM, Marc Zyngier <maz@misterjones.org> wrote:
> Eric,
>
> The attached patch tries to fix a bug I noticed while hacking on the
> max732x driver for interrupt support.
> According to the datasheets, open-drain pins have to be configured as
> output-high (which in that case is actually high impedance) to be used as
> input.
>
> Note that this patch has only been compile tested, as I still have to
> solder the actual chip to one of my boards...
>

Ack.

(PS: Sorry for late reply, overlooked.)
