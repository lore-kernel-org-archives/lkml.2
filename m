Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830Ab1HFPc3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 11:32:29 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63608 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191Ab1HFPc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 11:32:27 -0400
Date: Sat, 6 Aug 2011 17:32:13 +0200
From: Steffen Barszus <steffenbpunkt@googlemail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anssi Hannula <anssi.hannula@iki.fi>
Subject: Re: [PATCH 1/1] Input: ati_remote - extend keytable for medion
 remotes
Message-ID: <20110806173213.67f8acc7@grobi>
In-Reply-To: <20110525163204.GD22517@core.coreip.homeip.net>
References: <20110418104108.GA4876@atlantis.wh2.tu-dresden.de.de>
	<20110418104547.GB4876@atlantis.wh2.tu-dresden.de.de>
	<20110525163204.GD22517@core.coreip.homeip.net>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 May 2011 09:32:04 -0700
Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:

> Hi Jan,
> 
> On Mon, Apr 18, 2011 at 12:45:47PM +0200, Jan Losinski wrote:
> > This extends the ati_remote to support multiple keytables. The table
> > will be selected with the productId of the device.
> > 
> > It also provides a table for the medion rf remote control that
> > enables all buttons on it.
> > 
> 
> I am not a big fan of static keymaps in kernel drivers and would much
> more prefer driver supporting adjusting keymaps via EVIOCSKEYCODE
> ioctls. Unfortunately ati_remote key handling code is kind of involved
> and I am not sure what is the best way of wiring it up.
> 
> I believe Anssi Hannula (CCed) mentioned that he has a version of
> ati_remove ported to rc-core infrastructure that supports such
> remapping. Anssi, could you tell me what is the status of that driver?
> Is it usable with rc-core?

Jarod also had some interest in moving this to rc-core (but as he
stated no time soon) 

Could this be added in the meantime ? Anyone ? Whats missing ? 

:) 

Thanks
