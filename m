Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760972Ab2FDVgG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 17:36:06 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:53320 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754771Ab2FDVgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 17:36:04 -0400
Date: Mon, 4 Jun 2012 23:37:35 +0200
From: Fabio Baltieri <fabio.baltieri@gmail.com>
To: Shuah Khan <shuahkhan@gmail.com>
Cc: Bryan Wu <bryan.wu@canonical.com>, linux-leds@vger.kernel.org,
        linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH v2 1/3] leds: add oneshot blink functions
Message-ID: <20120604213735.GA1858@gmail.com>
References: <1338074364-1829-1-git-send-email-fabio.baltieri@gmail.com>
 <1338135226.2968.22.camel@lorien2>
 <20120531210800.GB2400@gmail.com>
 <1338565180.2618.9.camel@lorien2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338565180.2618.9.camel@lorien2>
X-Operating-System: Linux balto-eee 3.4.0-balto-eee-00005-ga209f76 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2012 at 09:39:40AM -0600, Shuah Khan wrote:
> 
> > 
> > There should be no compatibity issues with current timer-trigger calls,
> > can you be more specific?
> 
> My initial thought was that maybe you could create new namespace for
> this trigger instead of using delay_on and delay_off. However, after
> looking closely at the patch set you are proposing, since you are using
> delay_on and delay_off in led_cdev, I think you are ok.

Ok, the patch should integrate pretty well with existing software-timer
code, and delay_{on,off} retains the same meaning.

> Please make sure there is no regression in the ledtrig-timer use-cases,
> with the changes made to led-class and led-core. 

Of course, I've made many tests with mixes of led_trigger_blink() and
led_trigger_blink_oneshot() calls, and they seems to work samelessly.
Did you have any chance to test it?

If you think that the patch is good I'd like to consider that for
integration, so I can repost a modified version of my can-trigger
patch on the linux-can mailing list.

Fabio
