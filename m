Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760807Ab1LPVZW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 16:25:22 -0500
Received: from oproxy9.bluehost.com ([69.89.24.6]:37215 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754193Ab1LPVZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 16:25:15 -0500
Message-ID: <4EEBC555.4010600@xenotime.net>
Date: Fri, 16 Dec 2011 14:25:25 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        NeilBrown <neilb@suse.de>, Richard Purdie <rpurdie@rpsys.net>
Subject: Re: linux-next: Tree for Dec 16 (leds/tca6507)
References: <20111216170042.650147ec79e792dce950f6e3@canb.auug.org.au>
In-Reply-To: <20111216170042.650147ec79e792dce950f6e3@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2011 10:00 PM, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20111215:


When GPIOLIB is not enabled:

drivers/leds/leds-tca6507.c:158:20: error: field 'gpio' has incomplete type
drivers/leds/leds-tca6507.c: In function 'tca6507_gpio_set_value':
drivers/leds/leds-tca6507.c:534:29: warning: type defaults to 'int' in declaration of '__mptr'
drivers/leds/leds-tca6507.c:534:29: warning: initialization from incompatible pointer type
drivers/leds/leds-tca6507.c: In function 'tca6507_probe':
drivers/leds/leds-tca6507.c:618:3: error: implicit declaration of function 'gpiochip_add'
drivers/leds/leds-tca6507.c: In function 'tca6507_remove':
drivers/leds/leds-tca6507.c:651:3: error: implicit declaration of function 'gpiochip_remove'


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
