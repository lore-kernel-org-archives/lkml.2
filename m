Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609Ab2I0EIG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 00:08:06 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:50769 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab2I0EIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 00:08:04 -0400
MIME-Version: 1.0
In-Reply-To: <CACVXFVOV9GfWxmbxDhKCOd0UWRPoORj5=dSiKdQrwnkf3cdNJw@mail.gmail.com>
References: <CACVXFVOV9GfWxmbxDhKCOd0UWRPoORj5=dSiKdQrwnkf3cdNJw@mail.gmail.com>
Date: Thu, 27 Sep 2012 12:08:03 +0800
Message-ID: <CACVXFVPLacVi-tiurDBKsH-Y_nRv9r89vr0i7yJFn9croQc9WA@mail.gmail.com>
Subject: Re: Question on irq autoprobe
From: Ming Lei <tom.leiming@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 10:02 AM, Ming Lei <tom.leiming@gmail.com> wrote:
> Hi,
>
> I see the below comments on probe_irq_off:
>
>      *  BUGS: When used in a module (which arguably shouldn't happen)
>      *  nothing prevents two IRQ probe callers from overlapping. The
>      *  results of this are non-optimal.
>      */
>
> But from the code of probe_irq_on and probe_irq_off, the mutex of
> probing_active is held during the whole irq probe procedure, so
> I don't understand why the above said that 'nothing prevents two
> IRQ probe callers from overlapping", and why isn't the mutex of
> probing_active enough to avoid the overlapping?

Thomas, I really appreciate that if you may clarify the question, :-)


Thank,
-- 
Ming Lei
