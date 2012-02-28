Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932441Ab2B1C3Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 21:29:16 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:65492 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755528Ab2B1C3P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 21:29:15 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of mans.rullgard@linaro.org designates 10.52.76.164 as permitted sender) smtp.mail=mans.rullgard@linaro.org
MIME-Version: 1.0
In-Reply-To: <20120228010430.467184125@linuxfoundation.org>
References: <20120228010511.GA8453@kroah.com>
	<20120228010430.467184125@linuxfoundation.org>
Date: Tue, 28 Feb 2012 02:29:14 +0000
Message-ID: <CAG5Tg6VZR7fmbmxtn=8JXzmDhbJZftryDujtquWfFWJXSEs3LA@mail.gmail.com>
Subject: Re: [ 12/72] ARM: 7326/2: PL330: fix null pointer dereference in pl330_chan_ctrl()
From: Mans Rullgard <mans.rullgard@linaro.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Javi Merino <javi.merino@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 February 2012 01:04, Greg KH <gregkh@linuxfoundation.org> wrote:
> 3.2-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Javi Merino <javi.merino@arm.com>

I'm pretty sure I wrote that patch...

-- 
Mans Rullgard / mru
