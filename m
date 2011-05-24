Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754Ab1EXOJZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 10:09:25 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:45961 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752653Ab1EXOJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 10:09:24 -0400
Date: Tue, 24 May 2011 16:08:47 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: Richard Cochran <richardcochran@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] posix clocks: correct error value in posix_clock_poll()
Message-ID: <20110524160847.48ba7d34@absol.kitzblitz>
In-Reply-To: <20110524123432.GB2929@riccoc20.at.omicron.at>
References: <20110524125147.0eb112b5@absol.kitzblitz>
	<20110524123432.GB2929@riccoc20.at.omicron.at>
Organization: -
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwAQMAAABtzGvEAAAAAXNSR0IArs4c6QAAAAZQTFRF
 AJnV/f/88sgWwwAAAKNJREFUGNM10LENwyAQheFHKCgZgTVSRHI2gy5reROTDSiREvnyHhdXnwXS+
 T+ACJgBYTiGSmDDOTdR7XDeTi9ksxEcoKFcTOCJLO7kC5SWFjPZCR69nI9+x5u6OJM1RN5UYUiNKa
 ZRpHHUoqh1v8hKEZ1FSGCrYOvgVmxd9DIXcSJwLTycm7bj0e4wkJGB48w/FckAwUKl/OGDZAcqItk
 BU+wHXLqKsjYyPeMAAAAASUVORK5CYII=
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Richard Cochran <richardcochran@gmail.com>:
> On Tue, May 24, 2011 at 12:51:47PM +0200, Nicolas Kaiser wrote:
> > It looks to me like -ENODEV might not be a good return value
> > in poll(). Would POLLERR be the correct one in this case?

> The condition (!clk) is only satisfied when 'zombie' is set,
> indicating that the dynamic clock has disappeared. That is why the
> file operations uniformly return ENODEV. So, I think it makes sense
> the way that it is.
> 
> In addition, man 2 poll says,
> 
>    POLLERR
>           Error condition (output only).
> 
> so using that error code would be misleading, IMHO.

I see. Sorry for the noise.

Best regards,
Nicolas Kaiser
