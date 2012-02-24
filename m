Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533Ab2BXJPA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 04:15:00 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61757 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756286Ab2BXJO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 04:14:57 -0500
Date: Fri, 24 Feb 2012 01:14:52 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Daniel Kurtz <djkurtz@chromium.org>, Chung-yih Wang <cywang@chromium.org>,
        Alessandro Rubini <rubini@cvml.unipv.it>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CHROMIUM: Input: synaptics - filter out the events with
 low z values
Message-ID: <20120224091452.GD10763@core.coreip.homeip.net>
References: <1329896503-28394-1-git-send-email-cywang@chromium.org>
 <20120222083858.GA26570@polaris.bitmath.org>
 <CAGS+omCU9f=DyC442+4HOF=sGhZYXne+E2ephFiOmuj-XKciMA@mail.gmail.com>
 <20120222110459.GA28126@polaris.bitmath.org>
 <CAGS+omB0GCQHOjrb_T6h7DzHrH2sp4Xqb5av6JC-ttJ8HZ5BcQ@mail.gmail.com>
 <20120222152425.GA29436@polaris.bitmath.org>
 <20120224082706.GB18291@core.coreip.homeip.net>
 <20120224090835.GA2154@polaris.bitmath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120224090835.GA2154@polaris.bitmath.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 10:08:35AM +0100, Henrik Rydberg wrote:
> > > The most striking effect is the ability to better retain a
> > > drag. Although the statement was made in light of possible
> > > (1-strong,1-weak) packets, it should help in the 2-weak case too.
> > 
> > The bigger question is why is this needed in kernel. The original
> > hysteresis with BTN_TOUCH was done for sole benefit of mousedev so that
> > we could allow somewhat better transition from standard PS/2 mode into
> > native Synaptics mode with absolute coordinates at time when barely
> > anyone had Synaptics X driver installed. This was, what, 10 years ago?
> 
> The semi-mt behavior is obviously a special case, where userspace
> relies on the reported number of fingers to transition between one
> touch and two touches. There is no pressure information sent to
> userspace in this case, so the situation is in fact quite similar to
> the ancient mousedev situation.

We still report ABS_PRESSURE but maybe we should report ABS_MT_PRESSURE
as well?

-- 
Dmitry
