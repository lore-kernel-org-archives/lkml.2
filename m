Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758010Ab2ECSao (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 14:30:44 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:57511 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863Ab2ECSan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 14:30:43 -0400
To: Rupjyoti Sarmah <rsarmah@amcc.com>
cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, rsarmah@apm.com
From: Wolfgang Denk <wd@denx.de>
Subject: Re: [PATCH v16 01/10]USB/ppc4xx: Add Synopsys DWC OTG Register definitions
MIME-Version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8bit
In-reply-to: <201205031223.q43CN3LN022598@amcc.com>
References: <201205031223.q43CN3LN022598@amcc.com>
Comments: In-reply-to Rupjyoti Sarmah <rsarmah@amcc.com>
   message dated "Thu, 03 May 2012 17:53:03 +0530."
Date: Thu, 03 May 2012 20:30:37 +0200
Message-Id: <20120503183037.774D4204A81@gemini.denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Rupjyoti Sarmah,

In message <201205031223.q43CN3LN022598@amcc.com> you wrote:
> 
> Add Synopsys Design Ware core register definitions.

Olof Johansson <olof@lixom.net> has commented v15 of this patch as
follows:

> No, just start over from scratch. Just leave the crap driver behind,
> use it for reference but write the new one.
> 
> It's obvious given that you are already at iteration v15 and it's
> still looking this bad that this is not realistic to get reviewed and
> accepted as-is. I don't think staging is a good target either -- what
> the driver really needs is _functional_ cut-down to only cover the use
> cases that your product uses, and staging cleanups are mostly around
> style and refactoring, not changing, fixing or removing functionality.
> ...
> I don't think you understood what I meant. Try building an ARM config
> with this driver enabled, for example, and you'll see that it breaks
> the build.

See http://thread.gmane.org/gmane.linux.usb.general/53348/focus=53913
for the full context and other important comments.

It seems most of these requests have been ignored so far.

I would also like to point out that the same Synopsys USB controller
is used in a number of other SoCs (especially ARM chips), and
supported by other drivers, some of these even in mainline.

See http://thread.gmane.org/gmane.linux.usb.general/61714/focus=62139
for a related thread.


Instead of trying to add a completely new driver to mainline (and one
which has been repeatedly been rejected), I vote for focussing on the
existing driver code that is already in mainline, and testing and
improving this so we can use a single implementation of this driver
code for all SoCs that use the same IP block.


Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
panic: kernel trap (ignored)
