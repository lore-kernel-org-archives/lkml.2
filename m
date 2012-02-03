Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931Ab2BCIhQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 03:37:16 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33199 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813Ab2BCIhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 03:37:12 -0500
Date: Fri, 3 Feb 2012 00:37:08 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Dima Zavin <dima@android.com>
Cc: Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: evdev - fix variable initialisation
Message-ID: <20120203083707.GC24226@core.coreip.homeip.net>
References: <201201312224.46360.heiko@sntech.de>
 <CAPz4a6DDwt2uEX1o3ULSESjnVqMA1gBWoFP27XCviaOXd1-fpw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPz4a6DDwt2uEX1o3ULSESjnVqMA1gBWoFP27XCviaOXd1-fpw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 31, 2012 at 01:40:42PM -0800, Dima Zavin wrote:
> ugh, thanks for fixing this.
> 
> On Tue, Jan 31, 2012 at 1:24 PM, Heiko Stübner <heiko@sntech.de> wrote:
> > Commit 509f87c5f564 (evdev - do not block waiting for an event if fd
> > is nonblock) created a code path were it was possible to use retval
> > uninitialized.
> >
> > This could lead to the xorg evdev input driver getting corrupt data
> > and refusing to work with log messages like
> >        AUO-Pixcir touchscreen: Read error: Success
> >        sg060_keys: Read error: Success
> >        AUO-Pixcir touchscreen: Read error: Success
> >        sg060_keys: Read error: Success
> > (for drivers auo-pixcir-ts and gpio-keys).
> >
> > Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> 
> Acked-by: Dima Zavin <dima@android.com>
> 

Applied, thank you.

-- 
Dmitry
