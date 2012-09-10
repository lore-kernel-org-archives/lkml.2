Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237Ab2IJR4R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 13:56:17 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59136 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757142Ab2IJR4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 13:56:12 -0400
Date: Mon, 10 Sep 2012 19:57:25 +0200
From: Fabio Baltieri <fabio.baltieri@gmail.com>
To: linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Purdie <rpurdie@rpsys.net>, Bryan Wu <bryan.wu@canonical.com>
Subject: Re: [PATCH] leds: add led_trigger_rename function
Message-ID: <20120910175725.GB2006@gmail.com>
References: <1347204474-1694-1-git-send-email-fabio.baltieri@gmail.com>
 <20120910135535.GA2405@vandijck-laurijssen.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120910135535.GA2405@vandijck-laurijssen.be>
X-Operating-System: Linux balto-eee 3.6.0-rc3-balto-eee-00468-g15b91d3
 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 03:55:35PM +0200, Kurt Van Dijck wrote:
> On Sun, Sep 09, 2012 at 05:27:54PM +0200, Fabio Baltieri wrote:
> > Implements a led_trigger_rename() function to rename a trigger with
> > proper locking.
> This is the way to go.
> Maybe add 'default_trigger' tests? In a later phase?

Do you think that default_trigger should be processed on renames?  I
usually think of default_trigger as something just on boot time, but
that could make sense after all.

I think that could go for later phase anyway.

> > This also implies that "name" in "struct led_trigger" is not const
> > anymore.
> IMHO, this is wrong. This forces all other led_triggers
> to put their name in non-const storage.

Uh - is that really a problem?

Fabio

-- 
Fabio Baltieri
