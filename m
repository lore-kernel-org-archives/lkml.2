Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674Ab2AXXAz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 18:00:55 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:37571 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab2AXXAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 18:00:53 -0500
Message-ID: <1327446024.11738.4.camel@work-vm>
Subject: Re: [RFC][PATCH 2/3] clocksource: scx200_hrt: Convert scx200 to use
 clocksource_register_hz
From: John Stultz <john.stultz@linaro.org>
To: Jim Cromie <jim.cromie@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Date: Tue, 24 Jan 2012 15:00:24 -0800
In-Reply-To: <CAJfuBxwBfB7V_gikW44rTNAYvxKZwORwzdRrvyZM19feFwcwDQ@mail.gmail.com>
References: <1327363550-19952-1-git-send-email-john.stultz@linaro.org>
	 <1327363550-19952-3-git-send-email-john.stultz@linaro.org>
	 <CAJfuBxwBfB7V_gikW44rTNAYvxKZwORwzdRrvyZM19feFwcwDQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12012423-5518-0000-0000-000001C5C55B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-24 at 11:53 -0700, Jim Cromie wrote:
> On Mon, Jan 23, 2012 at 5:05 PM, John Stultz <john.stultz@linaro.org> wrote:
> > Converts the scx200 clocksource to using clocksource_register_hz.
> >
> > This wasn't a straight conversion, so would like some extra review
> > by the maintainers.
> >
> 
> hi John,
> 
> very nice.  Tested with mhz27 too.
> 
> Signed-off-by: Jim Cromie <jim.cromie@gmail.com>

I assume you mean Acked-by:/Tested-by: ?  Or are you going to push this
upstream?

thanks
-john


