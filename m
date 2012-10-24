Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933628Ab2JXNHJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 09:07:09 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:33456 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756144Ab2JXNHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 09:07:07 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1210241226060.31768@axis700.grange>
References: <Pine.LNX.4.64.1210241226060.31768@axis700.grange>
Date: Wed, 24 Oct 2012 21:07:05 +0800
Message-ID: <CACVXFVOv-zMj_cEyRuehhWMjCF1nvd-tkW7c8o5raHZoMbCZiQ@mail.gmail.com>
Subject: Re: [Q] "console=" command line ignored?
From: Ming Lei <tom.leiming@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        linux-sh@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 6:49 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> Hi
>
> I cannot seem to force selection of a serial console by specifying
> "console=ttySC0..." on the command line with modern (yesterday's "next")
> kernels. The kernel insists on
>
> console [tty0] enabled

Please see https://lkml.org/lkml/2012/10/23/307

>
> The reason might also well be, that the respective "sh-sci" driver is
> only registered later. I'll try to look at this in more detail - since
> when this is broken and how the registration order looked before. This is
> just a first heads-up in case someone has a solution immediately at hand.



Thanks,
-- 
Ming Lei
