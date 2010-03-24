Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315Ab0CXVCJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 17:02:09 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:57631 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751971Ab0CXVCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 17:02:08 -0400
Date: Wed, 24 Mar 2010 22:02:01 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Samuel Thibault <samuel.thibault@ens-lyon.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH -mmotm] leds-input: depends on INPUT
Message-ID: <20100324210201.GA6800@elf.ucw.cz>
References: <201003232301.o2NN1bms031050@imap1.linux-foundation.org>
 <4BAA658E.20400@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BAA658E.20400@oracle.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2010-03-24 12:18:38, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> leds-input uses input_*() functions so it should depend on INPUT.
> 
> leds-input.c:(.text+0x6e0513): undefined reference to `input_unregister_handle'
> leds-input.c:(.text+0x6e06eb): undefined reference to `input_inject_event'
> leds-input.c:(.text+0x6e0700): undefined reference to `input_inject_event'
> leds-input.c:(.text+0x6e0906): undefined reference to `input_register_handle'
> leds-input.c:(.text+0x6e0bdc): undefined reference to `input_unregister_handler'
> leds-input.c:(.init.text+0x285c8): undefined reference to `input_register_handler'
> leds-input.c:(.exit.text+0x7b04): undefined reference to `input_unregister_handler'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>
> Cc: Pavel Machek <pavel@ucw.cz>

ACK.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
