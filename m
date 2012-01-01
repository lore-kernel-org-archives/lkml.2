Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147Ab2AAQ0W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jan 2012 11:26:22 -0500
Received: from bues.ch ([80.190.117.144]:38156 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883Ab2AAQ0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jan 2012 11:26:21 -0500
Date: Sun, 1 Jan 2012 17:25:58 +0100
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oliver@neukum.org>, Matthew Garrett <mjg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: loading firmware while usermodehelper disabled.
Message-ID: <20120101172558.4155ffbe@milhouse>
In-Reply-To: <Pine.LNX.4.44L0.1201011105200.4534-100000@netrider.rowland.org>
References: <201201011322.34483.oliver@neukum.org>
	<Pine.LNX.4.44L0.1201011105200.4534-100000@netrider.rowland.org>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Jan 2012 11:17:52 -0500 (EST)
Alan Stern <stern@rowland.harvard.edu> wrote:

> As Linus pointed out, the real problem here is the firmware loader.  
> The way it is now, a driver can't always depend on the data being
> available, even during a normal boot.  It ought to use an asynchronous
> approach; then none of these problems would arise.

request_firmware_nowait() exists.

-- 
Greetings, Michael.
