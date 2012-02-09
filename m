Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918Ab2BIFMc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 00:12:32 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:45461 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab2BIFMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 00:12:31 -0500
Date: Thu, 9 Feb 2012 06:12:18 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Dmitry Antipov <dmitry.antipov@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org
Subject: Re: clock_getres() and real resolution
Message-ID: <20120209051218.GC2211@netboy.at.omicron.at>
References: <4F32A347.4090703@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F32A347.4090703@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 08, 2012 at 08:31:03AM -0800, Dmitry Antipov wrote:
> IIUC, an idea behind clock_getres() is to give a hint about the resolution of
> specified clock. This hint may be used by an application programmer to check whether
> this clock is suitable for a some purpose. So why clock_getres() always returns
> something like {0, 1} (if hrtimers are enabled) regardless of the underlying platform's
> real numbers?

I think "resolution" does not mean tick duration, but rather the finest timer unit.

HTH,
Richard
