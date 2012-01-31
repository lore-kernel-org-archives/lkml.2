Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510Ab2AaUTc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 15:19:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33971 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530Ab2AaUTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 15:19:31 -0500
Date: Tue, 31 Jan 2012 12:19:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "Linus Walleij" <linus.walleij@linaro.org>,
        "shreshthakumar.sahu@stericsson.com" 
	<shreshthakumar.sahu@stericsson.com>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 3/6] leds-lm3530: add lm3530_mode_get() in the
 dev_attr
Message-Id: <20120131121930.4cb1a05a.akpm@linux-foundation.org>
In-Reply-To: <B567DBAB974C0544994013492B949F8E3812DEC933@EXMAIL03.scwf.nsc.com>
References: <B567DBAB974C0544994013492B949F8E3812DEC933@EXMAIL03.scwf.nsc.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jan 2012 23:33:44 -0800
"Kim, Milo" <Milo.Kim@ti.com> wrote:

> To get information about brightness control mode, lm3530_mode_get() is added.

drivers/leds/leds-lm3530.c already has an implementation of
lm3530_mode_get().  I assume these patches were prepared against some
old kernel.  Please don't do that!


