Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab1AJOVu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 09:21:50 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37828 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350Ab1AJOVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 09:21:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=iMpANa/9lPlEO/lT5F0tFrwRyjcgVz9N2dsY9KUyQtIlW8LYeoWVo95hAlWtWrkpFw
         AuWQsoJPz5WRwXWzPkqd2mA5gkyENJUb9kkz/94TH+Ma1oe5VfngvvKkXIfUtjyU/QuU
         m9fHUcfaIFNR/ByxDDLvX1MilcyswNEcglou4=
MIME-Version: 1.0
In-Reply-To: <87mxncv3ge.fsf@inspiron.ap.columbia.edu>
References: <87mxncv3ge.fsf@inspiron.ap.columbia.edu>
Date: Mon, 10 Jan 2011 22:21:48 +0800
Message-ID: <AANLkTi=QV7wF3Z7J8eh3MkOJ1K=ZNLgHFinX8dJSuYeJ@mail.gmail.com>
Subject: Re: CPU Initiated DMA
From: Ming Lei <tom.leiming@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/1/8 Nikolaus Rath <Nikolaus@rath.org>:
Hi,

> Hello,
>
> I want to write a driver for a rather dumb PCI card, which cannot become
> bus master itself. Is it possible to use a DMA controller on the
> mainboard to still transfer data to the card without occupying the CPU?
>
> (I believe this is the way DMA used to work on ISA cards, but do recent
> x86 systems still have a DMA controller for the CPU?)
>
> Any pointers are greatly appreciated. I looked into "Linux Device
> Drivers", but the DMA chapter seems to be only about the device becoming
> busmaster.

Generally speaking, you can do it certainly if there is dma controller on
your system.

thanks,
-- 
Lei Ming
