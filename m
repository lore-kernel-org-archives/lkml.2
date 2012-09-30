Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434Ab2I3RoF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 13:44:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60280 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032Ab2I3RoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 13:44:02 -0400
Date: Sun, 30 Sep 2012 10:43:53 -0700
From: Jonathan Nieder <jrnieder@gmail.com>
To: Jim Hill <gjthill@gmail.com>
Cc: Alessandro Rubini <rubini@cvml.unipv.it>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        607242@bugs.debian.org
Subject: Re: [PATCH v2] psmouse: mitigate failing-mouse symptoms
Message-ID: <20120930174353.GA29129@elie.Belkin>
References: <4D2A3008.3000609@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D2A3008.3000609@gmail.com>
User-Agent: Mutt/1.5.21+51 (9e756d1adb76) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jim,

In January, 2011, Jim Hill wrote:

> Keep a failing PS/2 mouse usable until it's convenient to replace it.
> Filter incoming packets: drop invalid ones and attempt to correct for
> dropped bytes.
>
> New parameter 'filter' makes filtering and logging selectable, set to 0
> to shut off all effects.
[...]
> My mouse failed while in XP, but I didn't know it - it seemed it'd need
> cleaning soon. On booting into Linux, it was dangerous, wild slews and
> random clicks.  The difference was consistent, making it seem the
> problem wasn't the mouse.

I think this would be less controversial if the run-time default were
to disable the feature.  Then if lots of people are setting the
parameter and the idea proves itself, the default could change, and in
the meantime, people with broken setups would know about the breakage
and get a chance to look for other problems.

What do you think?

Thanks for your work,
Jonathan
