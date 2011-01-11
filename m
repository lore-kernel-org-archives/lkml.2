Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104Ab1AKOds (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 09:33:48 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:59047 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755788Ab1AKOdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 09:33:43 -0500
Date: Tue, 11 Jan 2011 15:33:37 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Rakesh Iyer <riyer@nvidia.com>
Cc: "'Dmitry Torokhov'" <dmitry.torokhov@gmail.com>,
        "jj@chaosbits.net" <jj@chaosbits.net>,
        "tsoni@codeaurora.org" <tsoni@codeaurora.org>,
        "shubhrajyoti@ti.com" <shubhrajyoti@ti.com>,
        "ccross@android.com" <ccross@android.com>,
        "konkers@android.com" <konkers@android.com>,
        "olof@lixom.net" <olof@lixom.net>, Andrew Chew <AChew@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: Re: [PATCH v3] input: tegra-kbc - Add tegra keyboard driver
Message-ID: <20110111143337.GB22390@atrey.karlin.mff.cuni.cz>
References: <1294422307-19107-1-git-send-email-riyer@nvidia.com> <20110110221624.GA16445@core.coreip.homeip.net> <1FC56210173BB445BD77F608D6FB8D03165A00805F@HQMAIL03.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1FC56210173BB445BD77F608D6FB8D03165A00805F@HQMAIL03.nvidia.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > +	int fifo[KBC_MAX_KPENT];
> > > +	const struct tegra_kbc_platform_data *pdata;
> > > +	int *plain_keycode;
> > > +	int *fn_keycode;
> > 
> > There should not be separate keycodes for FN and normal kys - FN is just
> > a modifier, like SHIFT or CTRL or ALT are and shoudl be handled in upper
> > layers.
> 
> We had the same thought regarding Function as a modifier akin to Shift, Ctrl an Alt.
> But this does not appear to be the case. 
> 
> This keyboard is used primarily for Laptop-like form factors where function keys are used to overload the existing keys. 
> In addition the Fn key mappings aren't identical in different keyboard layouts.
> 
> So at this point in order to function with the target hardware and
> the target operating system which is Chrome, this modifier
> keymap is necessary.

Please find a way to do this cleanly. Other machines (zaurus) have
similar keyboards...
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
