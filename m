Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921Ab1HRGCn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 02:02:43 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:56420 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533Ab1HRGCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 02:02:39 -0400
Date: Wed, 17 Aug 2011 23:02:33 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, JJ Ding <jj_ding@emc.com.tw>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>,
        Aaron Huang <aaron_huang@emc.com.tw>, Tom Lin <tom_lin@emc.com.tw>,
        Eric Piel <E.A.B.Piel@tudelft.nl>, Daniel Kurtz <djkurtz@chromium.org>,
        Chase Douglas <chase.douglas@canonical.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Alessandro Rubini <rubini@cvml.unipv.it>
Subject: Re: [PATCH 6/6] Input: elantech - add v3 hardware support
Message-ID: <20110818060233.GB10093@core.coreip.homeip.net>
References: <1313632629-23603-1-git-send-email-jj_ding@emc.com.tw>
 <1313632629-23603-7-git-send-email-jj_ding@emc.com.tw>
 <4E4C8758.4020205@cn.fujitsu.com>
 <4E4C8B63.7030108@cn.fujitsu.com>
 <4E4C91C4.2080408@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E4C91C4.2080408@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 18, 2011 at 12:15:00PM +0800, Wanlong Gao wrote:
> On 08/18/2011 11:47 AM, Li Zefan wrote:
> >>>+
> >>>+    case 3:
> >>>+        if (elantech_ps2_command(psmouse, NULL, ETP_PS2_CUSTOM_COMMAND) ||
> >>>+            elantech_ps2_command(psmouse, NULL, ETP_REGISTER_READWRITE) ||
> >>>+            elantech_ps2_command(psmouse, NULL, ETP_PS2_CUSTOM_COMMAND) ||
> >>>+            elantech_ps2_command(psmouse, NULL, reg) ||
> >>>+            elantech_ps2_command(psmouse, param, PSMOUSE_CMD_GETINFO)) {
> >>>+            rc = -1;
> >>>+        }
> >>Prefer to remove these big brace ?
> >>also with "case 1, case 2 "?
> >
> >Just wondering What's wrong with this piece of code and what do you
> >sugguest to improve it?
> 
> I think no need to add a '{}' with the *if* ?
> and remove the '{}' in whole elantech_read_reg() and
> elantech_write_reg(), right?
> 

In case when conditon "overpowers" the body (i.e. multi-line condition)
I prefer having braces so the body stands out.

Thanks.

-- 
Dmitry
