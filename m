Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260Ab2H3XuZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 19:50:25 -0400
Received: from mail.active-venture.com ([67.228.131.205]:50869 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954Ab2H3XuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 19:50:24 -0400
X-Originating-IP: 108.223.40.66
Date: Thu, 30 Aug 2012 16:50:36 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Jean Delvare <khali@linux-fr.org>, lm-sensors@lm-sensors.org
Subject: Re: [PATCH v2 1/2] linux/kernel.h: Introduce IDIV_ROUND_CLOSEST
Message-ID: <20120830235036.GA12543@roeck-us.net>
References: <1346171456-29255-1-git-send-email-linux@roeck-us.net>
 <20120830161532.0db909c9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120830161532.0db909c9.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 04:15:32PM -0700, Andrew Morton wrote:
> On Tue, 28 Aug 2012 09:30:55 -0700
> Guenter Roeck <linux@roeck-us.net> wrote:
> 
> > DIV_ROUND_CLOSEST returns a bad result for negative dividends:
> > 	DIV_ROUND_CLOSEST(-2, 2) = 0
> > 
> > Most of the time this does not matter. However, in the hardware monitoring
> > subsystem, it is sometimes used on integers which can be negative (such as
> > temperatures). Introduce new macro IDIV_ROUND_CLOSEST which also supports
> > negative dividends.
> > 
> 
> Can't we just fix DIV_ROUND_CLOSEST?  That will make it a bit slower
> but it's not exactly a speed demon right now.  And fixing
> DIV_ROUND_CLOSEST() might just fix other bugs that we don't know about
> yet.
> 
Sure, fine with me. I'll submit a patch. Let's see who starts screaming.

Guenter
