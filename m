Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140Ab0CXXGR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 19:06:17 -0400
Received: from solo.fdn.fr ([80.67.169.19]:34634 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751327Ab0CXXGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 19:06:16 -0400
Date: Thu, 25 Mar 2010 00:06:11 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH -mmotm] leds-input: depends on INPUT
Message-ID: <20100324230611.GB6118@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Pavel Machek <pavel@ucw.cz>, Randy Dunlap <randy.dunlap@oracle.com>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Richard Purdie <rpurdie@rpsys.net>
References: <201003232301.o2NN1bms031050@imap1.linux-foundation.org> <4BAA658E.20400@oracle.com> <20100324210201.GA6800@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100324210201.GA6800@elf.ucw.cz>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek, le Wed 24 Mar 2010 22:02:01 +0100, a écrit :
> On Wed 2010-03-24 12:18:38, Randy Dunlap wrote:
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > leds-input uses input_*() functions so it should depend on INPUT.
> > 
> > leds-input.c:(.text+0x6e0513): undefined reference to `input_unregister_handle'
> > leds-input.c:(.text+0x6e06eb): undefined reference to `input_inject_event'
> > leds-input.c:(.text+0x6e0700): undefined reference to `input_inject_event'
> > leds-input.c:(.text+0x6e0906): undefined reference to `input_register_handle'
> > leds-input.c:(.text+0x6e0bdc): undefined reference to `input_unregister_handler'
> > leds-input.c:(.init.text+0x285c8): undefined reference to `input_register_handler'
> > leds-input.c:(.exit.text+0x7b04): undefined reference to `input_unregister_handler'
> > 
> > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> > Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>
> > Cc: Pavel Machek <pavel@ucw.cz>
> 
> ACK.

ACK.

Samuel
