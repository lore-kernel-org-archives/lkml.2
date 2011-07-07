Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261Ab1GGWnb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 18:43:31 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:57879 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612Ab1GGWna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 18:43:30 -0400
MIME-Version: 1.0
In-Reply-To: <20110707231516.66cb90be@lxorguk.ukuu.org.uk>
References: <20110707220621.GA6922@patrik-macbook>
	<20110707231516.66cb90be@lxorguk.ukuu.org.uk>
Date: Fri, 8 Jul 2011 00:43:29 +0200
Message-ID: <CAMeQTsbA1be=M9bMzq7SsiGXr3nrRJKzOGStob7igz2xTPORgA@mail.gmail.com>
Subject: Re: gma500: Mask out bits not part of the page table base address
From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Umm yes I suppose if its already been enabled that'll be slightly
> important

Yes :) and I guess that the size (bits 3:1) of the gtt could theoretically be
something other than 512KB. Is it safe to just look at the pci resource length
or should one perhaps cross-check it against the control register?

Maybe I just worry too much
