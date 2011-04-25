Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932893Ab1DYUxT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:53:19 -0400
Received: from na3sys010aog112.obsmtp.com ([74.125.245.92]:36326 "HELO
	na3sys010aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932086Ab1DYUxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:53:16 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1104251432560.23304@p34.internal.lan>
References: <alpine.DEB.2.02.1104131139380.11270@p34.internal.lan> <alpine.DEB.2.02.1104251432560.23304@p34.internal.lan>
From: Roland Dreier <roland@kernel.org>
Date: Mon, 25 Apr 2011 13:52:52 -0700
X-Google-Sender-Auth: E6mq6jke9cGgq2w2Xz6aOb-pbHw
Message-ID: <BANLkTimV4Nse58oQsWZWKzMbC7Ldm4mRLA@mail.gmail.com>
Subject: Re: 2.6.38: rt2800usb: driver is crashing the kernel
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 25, 2011 at 11:35 AM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> I notice periodic kernel crashes when using wireless.
> Has anyone seen this using the rt2800usb driver?
>
> When the host is on the LAN (supermicro+intel), there are zero crashes.
> Since I don't have it in a location where I can use netdump over the
> LAN/wire, see the picture below for the kernel crash/OOPS on the console:
>
> http://home.comcast.net/~jpiszcz/20110425/kernel_crash.jpg [1.2m]

Unfortunately a lot of the crash has scrolled away.  Is there any way
you can change your console's text mode to, say, 50 lines so more info
is visible?
