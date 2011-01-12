Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579Ab1ALWCp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 17:02:45 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:41743 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756536Ab1ALWCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 17:02:43 -0500
Date: Wed, 12 Jan 2011 23:02:55 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Rakesh Iyer <riyer@nvidia.com>
Cc: "tsoni@codeaurora.org" <tsoni@codeaurora.org>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "shubhrajyoti@ti.com" <shubhrajyoti@ti.com>,
        "ccross@android.com" <ccross@android.com>,
        "konkers@android.com" <konkers@android.com>,
        "olof@lixom.net" <olof@lixom.net>, Andrew Chew <AChew@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: Re: [PATCH 1/1] input: tegra-kbc - Add tegra keyboard driver
Message-ID: <20110112220254.GA4214@elf.ucw.cz>
References: <1294869179-15102-1-git-send-email-riyer@nvidia.com>
 <1FC56210173BB445BD77F608D6FB8D03165A00806D@HQMAIL03.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1FC56210173BB445BD77F608D6FB8D03165A00806D@HQMAIL03.nvidia.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2011-01-12 13:59:45, Rakesh Iyer wrote:
> Hi all.
> 
> I apologize for not specifying the PATCH indicator as "PATCH v4".
> 
> Sorry for the inconvenience caused.

Well, that is not huge problem, but short note of changes from last
version would be welcome.

AFAICT, FN handling was reworked...?

> > +     KEY_F10, KEY_F9, KEY_BACKSPACE, KEY_3,
> > +             KEY_2, KEY_UP, KEY_PRINT, KEY_PAUSE,

But now I'm confused; does hardware have Fx keys (F10 above) or not?
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
