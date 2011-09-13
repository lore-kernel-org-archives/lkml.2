Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636Ab1IMBlC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 21:41:02 -0400
Received: from emcscan.emc.com.tw ([192.72.220.5]:51421 "EHLO
	emcscan.emc.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094Ab1IMBlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 21:41:00 -0400
From: JJ Ding <jj_ding@emc.com.tw>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>,
        Aaron Huang <aaron_huang@emc.com.tw>, Tom Lin <tom_lin@emc.com.tw>,
        =?utf-8?Q?=C3=89ric?= Piel <E.A.B.Piel@tudelft.nl>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Chase Douglas <chase.douglas@canonical.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Alessandro Rubini <rubini@cvml.unipv.it>
Subject: Re: [PATCH v5 0/8] Input: elantech: add support for newer hardware
In-Reply-To: <20110909173342.GB13555@core.coreip.homeip.net>
References: <1315189007-2179-1-git-send-email-jj_ding@emc.com.tw> <20110909173342.GB13555@core.coreip.homeip.net>
User-Agent: Notmuch/0.7 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Tue, 13 Sep 2011 09:43:30 +0800
Message-ID: <874o0h43p9.fsf@emc.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On Fri, 9 Sep 2011 10:33:43 -0700, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> Hi JJ,
> 
> On Mon, Sep 05, 2011 at 10:16:39AM +0800, JJ Ding wrote:
> > Hi Lists,
> > 
> > This is a series of patches to add support for newer generations of ELAN
> > touchpad.
> > 
> > Patches #1~#6 are essentially fixes and cleanups that pave the way for
> > patch #7 and patch #8, which really adds code for v3 and v4 hardware.
> > 
> > Any comments, suggestoins are welcome.
> > 
> 
> OK, I applied all 8 patches to my 3.2 queue (and will push out once
> kernel.org is restored) so any followups needs to be sent relative to
> these 8.
> 
> Thanks.

Happy to hear that. Thank you very much.
And thank all for reviewing and testing this series.

jj
> -- 
> Dmitry
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
