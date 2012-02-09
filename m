Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757988Ab2BISkc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 13:40:32 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64318 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559Ab2BISkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 13:40:31 -0500
Date: Thu, 9 Feb 2012 19:40:21 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Dmitry Antipov <dmitry.antipov@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org
Subject: Re: clock_getres() and real resolution
Message-ID: <20120209184019.GA2217@netboy.at.omicron.at>
References: <4F32A347.4090703@linaro.org>
 <20120209051218.GC2211@netboy.at.omicron.at>
 <4F33910D.2030409@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F33910D.2030409@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 09, 2012 at 01:25:33AM -0800, Dmitry Antipov wrote:

> Old Sun Fire 880, SunOS 5.10 Generic_139555-08.
> 
> 100ns precision with 10ms "finest timer unit"???

I thought this list was about Linux kernel development, but now it
seems to be about Sun's old bugs.

Richard
